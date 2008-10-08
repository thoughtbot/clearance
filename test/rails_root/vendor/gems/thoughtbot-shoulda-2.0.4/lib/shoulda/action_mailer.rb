require 'shoulda'
require 'shoulda/action_mailer/assertions'

module Test # :nodoc: all
  module Unit
    class TestCase
      include ThoughtBot::Shoulda::ActionMailer::Assertions
    end
  end
end
