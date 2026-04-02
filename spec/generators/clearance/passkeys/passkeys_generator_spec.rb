require "spec_helper"
require "generators/clearance/passkeys/passkeys_generator"

describe Clearance::Generators::PasskeysGenerator, :generator do
  describe "add_webauthn_id_to_users migration" do
    it "is created when users table has no webauthn_id column" do
      stub_columns_for_users(without: "webauthn_id")
      stub_passkeys_table_absent

      run_generator
      migration = migration_file("db/migrate/add_webauthn_id_to_users.rb")

      expect(migration).to exist
      expect(migration).to have_correct_syntax
      expect(migration).to contain("add_column :users, :webauthn_id, :string")
      expect(migration).to contain("add_index :users, :webauthn_id, unique: true")
    end

    it "is not created when webauthn_id column already exists" do
      stub_columns_for_users(with: "webauthn_id")
      stub_passkeys_table_absent

      run_generator
      migration = migration_file("db/migrate/add_webauthn_id_to_users.rb")

      expect(migration).not_to exist
    end
  end

  describe "create_passkeys migration" do
    it "is created when passkeys table does not exist" do
      stub_columns_for_users(without: "webauthn_id")
      stub_passkeys_table_absent

      run_generator
      migration = migration_file("db/migrate/create_passkeys.rb")

      expect(migration).to exist
      expect(migration).to have_correct_syntax
      expect(migration).to contain("create_table :passkeys")
      expect(migration).to contain("t.references :user, null: false, foreign_key: true")
      expect(migration).to contain("t.string :label, null: false")
      expect(migration).to contain("t.string :external_id, null: false")
      expect(migration).to contain("t.string :public_key, null: false")
      expect(migration).to contain("t.integer :sign_count, null: false, default: 0")
      expect(migration).to contain("add_index :passkeys, :external_id, unique: true")
    end

    it "is not created when passkeys table already exists" do
      stub_columns_for_users(without: "webauthn_id")
      stub_passkeys_table_present

      run_generator
      migration = migration_file("db/migrate/create_passkeys.rb")

      expect(migration).not_to exist
    end
  end

  def stub_columns_for_users(without: nil, with: nil)
    column = Struct.new(:name)
    columns = with ? [column.new(with)] : []

    allow(ActiveRecord::Base.connection)
      .to receive(:data_source_exists?).with(:users).and_return(true)
    allow(ActiveRecord::Base.connection)
      .to receive(:columns).with(:users).and_return(columns)
  end

  def stub_passkeys_table_absent
    allow(ActiveRecord::Base.connection)
      .to receive(:data_source_exists?).with(:passkeys).and_return(false)
  end

  def stub_passkeys_table_present
    allow(ActiveRecord::Base.connection)
      .to receive(:data_source_exists?).with(:passkeys).and_return(true)
  end
end
