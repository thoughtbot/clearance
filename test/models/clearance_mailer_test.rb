require 'test_helper'

class ClearanceMailerTest < ActiveSupport::TestCase

  context "A change password email" do
    setup do
      @user  = Factory(:user)
      @email = ClearanceMailer.create_change_password @user
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

  context "A confirmation email" do
    setup do
      @user  = Factory(:user)
      @email = ClearanceMailer.create_confirmation @user
    end

    should "be from DO_NOT_REPLY" do
      assert_match /#{@email.from[0]}/i, Clearance.configuration.mailer_sender
    end

    should "be sent to user" do
      assert_match /#{@user.email}/i, @email.to.first
    end

    should "set its subject" do
      assert_match /Account confirmation/, @email.subject
    end

    should "contain a link to confirm the user's account" do
      host = ActionMailer::Base.default_url_options[:host]
      regexp = %r{http://#{host}/users/#{@user.id}/confirmation/new\?token=#{@user.confirmation_token}}
      assert_match regexp, @email.body
    end
  end

end
