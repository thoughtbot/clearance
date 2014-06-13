require "action_mailer"
require "email_spec"

RSpec.configure do |config|
  config.include(EmailSpec::Helpers, type: :feature)

  config.before(:each, type: :feature) do
    ActionMailer::Base.deliveries = []
  end
end
