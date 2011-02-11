@disable-bundler
Feature: integrate with application

  Background:
    When I successfully run "rails new testapp"
    And I cd to "testapp"
    And I remove the file "public/index.html"
    And I remove the file "app/views/layouts/application.html.erb"
    And I configure ActionMailer to use "localhost" as a host
    And I configure a root route
    And I add the "cucumber-rails" gem
    And I add the "capybara" gem
    And I add the "rspec-rails" gem
    And I add the "formtastic" gem
    And I add the "factory_girl_rails" gem
    And I add the "dynamic_form" gem
    And I add the "clearance" gem from this project
    And I add the "diesel" gem
    And I run "bundle install --local"
    And I successfully run "rails generate cucumber:install"
    And I disable Capybara Javascript emulation
    And I successfully run "rails generate clearance:features"

  Scenario: generate a Rails app, run the generators, and run the tests
    When I successfully run "rails generate clearance:install"
    And I successfully run "rake db:migrate --trace"
    And I successfully run "rake --trace"
    Then the output should contain "passed"
    And the output should not contain "failed"
    And the output should not contain "Could not find generator"

  Scenario: Developer already has a users table in their database
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
    And I successfully run "rake db:migrate --trace"
    And I successfully run "rails generate clearance:install"
    And I successfully run "rake db:migrate --trace"
    And I successfully run "rake --trace"
    Then the output should contain "passed"
    And the output should not contain "failed"
    And the output should not contain "Could not find generator"

