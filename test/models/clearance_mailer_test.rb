require 'test_helper'

class ClearanceMailerTest < ActiveSupport::TestCase
  context "A change password email" do
    setup do
      @user  = Factory(:user)
      @user.forgot_password!
      @email = ClearanceMailer.change_password @user
    end

    should "be from DO_NOT_REPLY" do
      assert_match /#{@email.from[0]}/i, Clearance.configuration.mailer_sender
    end

    should "be sent to user" do
      assert_match /#{@user.email}/i, @email.to.first
    end

    should "contain a link to edit the user's password" do
      host = ActionMailer::Base.default_url_options[:host]
      regexp = %r{http://#{host}/users/#{@user.id}/password/edit\?token=#{@user.confirmation_token}}
      assert_match regexp, @email.body
    end

    should "set its subject" do
      assert_match /Change your password/, @email.subject
    end
  end
end
