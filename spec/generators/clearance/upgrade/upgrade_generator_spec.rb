require "spec_helper"
require "generators/clearance/upgrade/upgrade_generator"

describe Clearance::Generators::UpgradeGenerator, :generator do
  it "copies a database migration to the host application" do
    run_generator

    migration = migration_file(
      "db/migrate/remove_confirmation_token_from_users.rb",
    )

    expect(migration).to exist
    expect(migration).to have_correct_syntax
    expect(migration).to contain("remove_column :users, :confirmation_token")
  end
end
