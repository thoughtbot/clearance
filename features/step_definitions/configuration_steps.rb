When /^I configure ActionMailer to use "([^"]+)" as a host$/ do |host|
  mailer_config = "config.action_mailer.default_url_options = { :host => '#{host}' }"
  path = "config/application.rb"
  in_current_dir do
    contents = IO.read(path)
    contents.sub!(/(class .* < Rails::Application)/, "\\1\n#{mailer_config}")
    File.open(path, "w") { |file| file.write(contents) }
  end
end

When /^I configure a root route$/ do
  route = "root :to => 'home#show'"
  path = "config/routes.rb"
  in_current_dir do
    contents = IO.read(path)
    contents.sub!(/(\.routes\.draw do)/, "\\1\n#{route}\n")
    File.open(path, "w") { |file| file.write(contents) }
  end
  write_file("app/controllers/home_controller.rb", <<-CONTROLLER)
  class HomeController < ApplicationController
    def show
      render :text => "", :layout => "application"
    end
  end
  CONTROLLER
end

When /^I disable Capybara Javascript emulation$/ do
  in_current_dir do
    path = "features/support/env.rb"
    contents = IO.read(path)
    contents.sub!(%{require 'cucumber/rails/capybara_javascript_emulation'},
                  "# Disabled")
    File.open(path, "w") { |file| file.write(contents) }
  end
end

When /^I copy the locked Gemfile from this project$/ do
  in_current_dir do
    FileUtils.cp(File.join(PROJECT_ROOT, 'Gemfile.lock'), 'Gemfile.lock')
  end
end
