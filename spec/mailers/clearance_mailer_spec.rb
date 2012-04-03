require 'spec_helper'

describe ClearanceMailer do
  before do
    @user  = create(:user)
    @user.forgot_password!
    @email = ClearanceMailer.change_password(@user)
  end

  it "should be from DO_NOT_REPLY" do
    Clearance.configuration.mailer_sender.should =~ /#{@email.from[0]}/i
  end

  it "should be sent to user" do
    @email.to.first.should =~ /#{@user.email}/i
  end

  it "should contain a link to edit the user's password" do
    host = ActionMailer::Base.default_url_options[:host]
    regexp = %r{http://#{host}/users/#{@user.id}/password/edit\?token=#{@user.confirmation_token}}
    @email.body.to_s.should =~ regexp
  end

  it "should set its subject" do
    @email.subject.should =~ /Change your password/
  end
end
