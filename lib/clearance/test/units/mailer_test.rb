module Clearance
  module MailerTest
  
    def self.included(base)
      base.class_eval do
        context "A change password email" do
          setup do
            @user = Factory :user
            @email = Mailer.create_change_password @user
          end

          should "set its from address to 'donotreply@example.com'" do
            assert_equal 'donotreply@example.com', @email.from[0]
          end

          should "contain a link to edit the user's password" do
            host = ActionMailer::Base.default_url_options[:host]
            regexp = %r{http://#{host}/users/#{@user.id}/password/edit\?email=#{@user.email.gsub("@", "%40")}&amp;password=#{@user.crypted_password}}
            assert_match regexp, @email.body
          end

          should "be sent to the user" do
            assert_equal [@user.email], @email.to
          end

          should "have a subject of '[YOUR APP] Request to change your password'" do
            assert_equal "[YOUR APP] Request to change your password", @email.subject
          end
        end
      end
    end
  
  end
end