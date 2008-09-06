module ThoughtBot # :nodoc:
  module Shoulda # :nodoc:
    module ActionMailer # :nodoc:
      module Assertions
        # Asserts that an email was delivered.  Can take a block that can further
        # narrow down the types of emails you're expecting.
        #
        #  assert_sent_email
        #
        # Passes if ActionMailer::Base.deliveries has an email
        #
        #  assert_sent_email do |email|
        #    email.subject =~ /hi there/ && email.to.include?('none@none.com')
        #  end
        #
        # Passes if there is an email with subject containing 'hi there' and
        # 'none@none.com' as one of the recipients.
        #
        def assert_sent_email
          emails = ::ActionMailer::Base.deliveries
          assert !emails.empty?, "No emails were sent"
          if block_given?
            matching_emails = emails.select {|email| yield email }
            assert !matching_emails.empty?, "None of the emails matched."
          end
        end

        # Asserts that no ActionMailer mails were delivered
        #
        #  assert_did_not_send_email
        def assert_did_not_send_email
          msg = "Sent #{::ActionMailer::Base.deliveries.size} emails.\n"
          ::ActionMailer::Base.deliveries.each { |m| msg << "  '#{m.subject}' sent to #{m.to.to_sentence}\n" }
          assert ::ActionMailer::Base.deliveries.empty?, msg
        end
      end
    end
  end
end
