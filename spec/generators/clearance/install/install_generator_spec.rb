require "spec_helper"
require "generators/clearance/install/install_generator"

describe Clearance::Generators::InstallGenerator, :generator do
  def get_migration(path)
    Pathname.new(migration_file(path))
  end

  describe "initializer" do
    it "is copied to the application" do
      provide_existing_application_controller

      run_generator
      initializer = file("config/initializers/clearance.rb")

      expect(initializer).to exist
      expect(initializer).to have_correct_syntax
      expect(initializer).to contain("Clearance.configure do |config|")
    end
  end

  describe "application controller" do
    it "includes Clearance::Controller" do
      provide_existing_application_controller

      run_generator
      application_controller = file("app/controllers/application_controller.rb")

      expect(application_controller).to have_correct_syntax
      expect(application_controller).to contain("include Clearance::Controller")
    end
  end

  describe "user_model" do
    context "no existing user class" do
      it "creates a user class including Clearance::User" do
        provide_existing_application_controller

        run_generator
        user_class = file("app/models/user.rb")

        expect(user_class).to exist
        expect(user_class).to have_correct_syntax
        expect(user_class).to contain_models_inherit_from
        expect(user_class).to contain("include Clearance::User")
      end
    end

    context "user class already exists" do
      it "includes Clearance::User" do
        provide_existing_application_controller
        provide_existing_user_class

        run_generator
        user_class = file("app/models/user.rb")

        expect(user_class).to exist
        expect(user_class).to have_correct_syntax
        expect(user_class).to contain_models_inherit_from
        expect(user_class).to contain("include Clearance::User")
        expect(user_class).to have_method("previously_existed?")
      end
    end
  end

  describe "user migration" do
    context "users table does not exist" do
      it "creates a migration to create the users table" do
        provide_existing_application_controller
        table_does_not_exist(:users)

        run_generator
        migration = get_migration("db/migrate/create_users.rb")

        expect(migration).to exist
        expect(migration).to have_correct_syntax
        expect(migration).to contain("create_table :users do")
      end

      context "active record configured for uuid" do
        around do |example|
          preserve_original_primary_key_type_setting do
            Rails.application.config.generators do |g|
              g.orm :active_record, primary_key_type: :uuid
            end
            example.run
          end
        end

        it "creates a migration to create the users table with key type set" do
          provide_existing_application_controller
          table_does_not_exist(:users)

          run_generator
          migration = get_migration("db/migrate/create_users.rb")

          expect(migration).to exist
          expect(migration).to have_correct_syntax
          expect(migration).to contain("create_table :users, id: :uuid do")
        end
      end
    end

    context "existing users table with all clearance columns and indexes" do
      it "does not create a migration" do
        provide_existing_application_controller

        run_generator
        create_migration = get_migration("db/migrate/create_users.rb")
        add_migration = get_migration("db/migrate/add_clearance_to_users.rb")

        expect(create_migration).not_to exist
        expect(add_migration).not_to exist
      end
    end

    context "existing users table missing some columns and indexes" do
      it "create a migration to add missing columns and indexes" do
        provide_existing_application_controller
        Struct.new("Named", :name)
        existing_columns = [Struct::Named.new("remember_token")]
        existing_indexes = [Struct::Named.new("index_users_on_remember_token")]

        allow(ActiveRecord::Base.connection).to receive(:columns).
          with(:users).
          and_return(existing_columns)

        allow(ActiveRecord::Base.connection).to receive(:indexes).
          with(:users).
          and_return(existing_indexes)

        run_generator
        migration = get_migration("db/migrate/add_clearance_to_users.rb")

        expect(migration).to exist
        expect(migration).to have_correct_syntax
        expect(migration).to contain("change_table :users")
        expect(migration).to contain("t.string :email")
        expect(migration).to contain("add_index :users, :email")
        expect(migration).not_to contain("t.string :remember_token")
        expect(migration).not_to contain("add_index :users, :remember_token")
        expect(migration).to(
          contain("add_index :users, :confirmation_token, unique: true"),
        )
        expect(migration).to(
          contain("remove_index :users, :confirmation_token, unique: true"),
        )
      end
    end
  end

  def table_does_not_exist(name)
    connection = ActiveRecord::Base.connection
    allow(connection).to receive(:data_source_exists?).
      with(name).
      and_return(false)
  end

  def preserve_original_primary_key_type_setting
    active_record = Rails.configuration.generators.active_record
    active_record ||= Rails.configuration.generators.options[:active_record]
    original = active_record[:primary_key_type]

    yield

    Rails.application.config.generators do |g|
      g.orm :active_record, primary_key_type: original
    end
  end

  def contain_models_inherit_from
    contain "< #{models_inherit_from}\n"
  end

  def models_inherit_from
    "ApplicationRecord"
  end
end
