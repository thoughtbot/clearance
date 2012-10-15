Feature: add migrations to the project

  Background:
    Given I have a project with clearance
    And I run `bundle install --local`

  Scenario: Users table does not exist
    And I successfully run `bundle exec rails generate clearance:install`
    And I successfully run `ls db/migrate`
    Then the output should contain:
      """
      create_users.rb
      """

  Scenario: Users table without clearance fields exists in the database
    When I write to "db/migrate/001_create_users.rb" with:
      """
      class CreateUsers < ActiveRecord::Migration
        def self.up
          create_table(:users) do |t|
            t.string :email
            t.string :name
          end
        end
        def self.down
        end
      end
      """
    And I successfully run `bundle exec rake db:migrate --trace`
    And I successfully run `bundle exec rails generate clearance:install`
    And I successfully run `ls db/migrate`
    Then the output should contain:
      """
      add_clearance_to_users.rb
      """

  Scenario: Users table with clearance fields exists in the database
    When I write to "db/migrate/001_create_users.rb" with:
      """
      class CreateUsers < ActiveRecord::Migration
        def self.up
          create_table :users  do |t|
            t.timestamps :null => false
            t.string :email, :null => false
            t.string :encrypted_password, :limit => 128, :null => false
            t.string :confirmation_token, :limit => 128
            t.string :remember_token, :limit => 128, :null => false
          end

          add_index :users, :email
          add_index :users, :remember_token
        end

        def self.down
          drop_table :users
        end
      end
      """
    And I successfully run `bundle exec rake db:migrate --trace`
    And I successfully run `bundle exec rails generate clearance:install`
    And I successfully run `ls db/migrate`
    Then the output should not contain:
      """
      add_clearance_to_users.rb
      """
