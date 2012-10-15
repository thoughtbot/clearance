When "I have a project with clearance and the following gems:" do |table|
  step "I have a project with clearance"

  table.map_column!('gem') do |gem|
    step %Q{ And I add the "#{gem}" gem }
  end
end

When "I have a project with clearance" do
  step "I successfully run `bundle exec rails new testapp`"

  steps %Q{
    And I cd to "testapp"
    And I remove the file "public/index.html"
    And I remove the file "app/views/layouts/application.html.erb"
    And I configure ActionMailer to use "localhost" as a host
    And I configure a root route
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

When /^I copy the locked Gemfile from this project$/ do
  in_current_dir do
    FileUtils.cp(File.join(PROJECT_ROOT, 'Gemfile.lock'), 'Gemfile.lock')
  end
end
