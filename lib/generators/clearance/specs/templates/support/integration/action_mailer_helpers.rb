module Integration
  module ActionMailerHelpers
    def mailer_should_have_delivery(recipient, subject, body)
      ActionMailer::Base.deliveries.should_not be_empty

      message = ActionMailer::Base.deliveries.any? do |email|
        email.to == [recipient] &&
          email.subject =~ /#{subject}/i &&
          email.body =~ /#{body}/
      end

      message.should be
    end

    def mailer_should_have_no_deliveries
      ActionMailer::Base.deliveries.should be_empty
    end
  end
end
