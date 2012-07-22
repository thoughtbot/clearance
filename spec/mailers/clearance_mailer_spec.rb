require 'spec_helper'

describe ClearanceMailer do
  before do
    @user  = create(:user)
    @user.forgot_password!
    @email = ClearanceMailer.change_password(@user)
  end

  it 'is from DO_NOT_REPLY' do
    Clearance.configuration.mailer_sender.should =~ /#{@email.from[0]}/i
  end

  it 'is sent to user' do
    @email.to.first.should =~ /#{@user.email}/i
  end

  it 'contains a link to edit the password' do
    host = ActionMailer::Base.default_url_options[:host]
    regexp = %r{http://#{host}/users/#{@user.id}/password/edit\?token=#{@user.confirmation_token}}
    @email.body.to_s.should =~ regexp
  end

  it 'should set its subject' do
    @email.subject.should =~ /Change your password/
  end
end
