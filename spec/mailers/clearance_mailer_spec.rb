require 'spec_helper'

describe ClearanceMailer do
  before do
    @user  = create(:user)
    @user.forgot_password!
    @email = ClearanceMailer.change_password(@user)
  end

  it 'is from DO_NOT_REPLY' do
    expect(Clearance.configuration.mailer_sender).to match(/#{@email.from[0]}/i)
  end

  it 'is sent to user' do
    expect(@email.to.first).to match(/#{@user.email}/i)
  end

  it 'contains a link to edit the password' do
    host = ActionMailer::Base.default_url_options[:host]
    regexp = %r{http://#{host}/users/#{@user.id}/password/edit\?token=#{@user.confirmation_token}}
    expect(@email.body.to_s).to match(regexp)
  end

  it 'sets its subject' do
    expect(@email.subject).to match(/Change your password/)
  end

  it 'contains opening text in the body' do
    expect(@email.body).to match(/a link to change your password/)
  end

  it 'contains closing text in the body' do
    expect(@email.body).to match(/Your password has not been changed/)
  end
end
