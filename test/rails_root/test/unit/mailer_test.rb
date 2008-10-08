require File.dirname(__FILE__) + '/../test_helper'

class MailerTest < ActionMailer::TestCase
  tests Mailer
  include Clearance::MailerTest
end
