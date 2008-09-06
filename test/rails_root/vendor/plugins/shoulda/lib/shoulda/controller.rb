require 'shoulda'
require 'shoulda/controller/helpers'
require 'shoulda/controller/resource_options'
require 'shoulda/controller/macros'

module Test # :nodoc: all
  module Unit
    class TestCase
      extend ThoughtBot::Shoulda::Controller::Macros
      include ThoughtBot::Shoulda::Controller::Helpers
      ThoughtBot::Shoulda::Controller::VALID_FORMATS.each do |format|
        include "ThoughtBot::Shoulda::Controller::#{format.to_s.upcase}".constantize
      end
    end
  end
end

require 'shoulda/active_record/assertions'
require 'shoulda/action_mailer/assertions'

module ActionController #:nodoc: all
  module Integration
    class Session
      include ThoughtBot::Shoulda::Assertions
      include ThoughtBot::Shoulda::Helpers
      include ThoughtBot::Shoulda::ActiveRecord::Assertions
      include ThoughtBot::Shoulda::ActionMailer::Assertions
    end
  end
end
