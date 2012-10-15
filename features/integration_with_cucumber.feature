Feature: integrate cucumber features with application

  Background:
    When I successfully run `bundle exec rails new testapp`
    And I cd to "testapp"
    And I remove the file "public/index.html"
    And I remove the file "app/views/layouts/application.html.erb"
    And I configure ActionMailer to use "localhost" as a host
    And I configure a root route
    And I add the "cucumber-rails" gem
    And I add the "capybara" gem
    And I add the "rspec-rails" gem
    And I add the "factory_girl_rails" gem
    And I add the "database_cleaner" gem
    And I add the "clearance" gem from this project
    And I run `bundle install --local`
    And I successfully run `bundle exec rails generate cucumber:install`
    And I successfully run `bundle exec rails generate clearance:features`

  Scenario: generate a Rails app, run the generators, and run the tests
    When I successfully run `bundle exec rails generate clearance:install`
    Then the output should contain "Next steps"
    When I successfully run `bundle exec rake db:migrate --trace`
    And I successfully run `bundle exec rake --trace`
    Then the output should contain "passed"
    And the output should not contain "failed"
    And the output should not contain "Could not find generator"
