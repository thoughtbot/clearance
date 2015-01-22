require "spec_helper"
require "generators/clearance/password_reset_migration/password_reset_migration_generator"

describe Clearance::Generators::PasswordResetMigrationGenerator, :generator do
  it "creates a migration for the password resets table" do
    provide_existing_application_controller

    run_generator

    migration = migration_file("db/migrate/create_password_resets.rb")
    expect(migration).to exist
    expect(migration).to have_correct_syntax
    expect(migration).to contain("create_table :password_resets")
  end

  it "creates a migration to drop the confirmation_token column in users table" do
    provide_existing_application_controller

    run_generator

    migration = migration_file("db/migrate/remove_confirmation_token_from_users.rb")
    expect(migration).to exist
    expect(migration).to have_correct_syntax
    expect(migration).to contain("remove_column :users, :confirmation_token")
  end
end
