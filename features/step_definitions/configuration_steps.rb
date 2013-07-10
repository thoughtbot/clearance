When /^I install dependencies$/ do
  step "I successfully run `bundle install --local`"
end

When "I have a project with clearance and the following gems:" do |table|
  step "I have a project with clearance"

  table.rows.flatten.each do |gem|
    step %Q{I add the "#{gem}" gem}
  end
end

When "I have a project with clearance" do
  Bundler.with_original_env do
    step "I successfully run `bundle exec rails new testapp --skip-bundle --skip-javascript --skip-sprockets`"
  end

  step 'I cd to "testapp"'

  unless Clearance::Testing.rails4?
    step 'I remove the file "public/index.html"'
  end

  steps %Q{
    And I remove the file "app/views/layouts/application.html.erb"
    And I configure ActionMailer to use "localhost" as a host
    And I configure a root route
    And I remove the "turn" gem from this project
    And I add the "clearance" gem from this project
  }
end

When /^I configure ActionMailer to use "([^"]+)" as a host$/ do |host|
  mailer_config = "config.action_mailer.default_url_options = { :host => '#{host}' }"
  path = 'config/application.rb'

  in_current_dir do
    contents = IO.read(path)
    contents.sub!(/(class .* < Rails::Application)/, "\\1\n#{mailer_config}")
    File.open(path, "w") { |file| file.write(contents) }
  end
end

When /^I configure a root route$/ do
  route = "root :to => 'home#show'"
  path = 'config/routes.rb'

  in_current_dir do
    contents = IO.read(path)
    contents.sub!(/(\.routes\.draw do)/, "\\1\n#{route}\n")
    File.open(path, 'w') { |file| file.write(contents) }
  end

  write_file('app/controllers/home_controller.rb', <<-CONTROLLER)
  class HomeController < ApplicationController
    def show
      render :text => '', :layout => 'application'
    end
  end
  CONTROLLER
end

When /^I configure test-unit$/ do
  factories_path = File.join(
    'lib', 'generators', 'clearance', 'specs', 'templates', 'factories',
    'clearance.rb'
  )
  steps %Q{
    When I append to "test/test_helper.rb" with:
    """
    require 'clearance/testing'
    """
    And I overwrite "test/#{controller_test_dir}/posts_controller_test.rb" with:
    """
    require 'test_helper'

    class PostsControllerTest < ActionController::TestCase
      test 'should get index' do
        sign_in
        get :index
        assert_response :success
      end
    end
    """
    And I write to "test/factories.rb" with:
    """
    #{File.read(factories_path)}
    """
  }
end

When /^I create a simple migration$/ do
  steps %Q{
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
  }
end

When /^I create a migration with clearance fields$/ do
  steps %Q{
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
  }
end

def controller_test_dir
  if Clearance::Testing.rails4?
    'controllers'
  else
    'functional'
  end
end
