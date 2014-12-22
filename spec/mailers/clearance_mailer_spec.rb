require "spec_helper"

describe ClearanceMailer do
  it "is from DO_NOT_REPLY" do
    user = create(:user)
    user.forgot_password!

    email = ClearanceMailer.change_password(user)

    expect(Clearance.configuration.mailer_sender).to eq(email.from[0])
  end

  it "is sent to user" do
    user = create(:user)
    user.forgot_password!

    email = ClearanceMailer.change_password(user)

    expect(email.to.first).to eq(user.email)
  end

  it "contains a link to edit the password" do
    user = create(:user)
    user.forgot_password!
    host = ActionMailer::Base.default_url_options[:host]
    link = "http://#{host}/users/#{user.id}/password/edit" \
      "?token=#{user.confirmation_token}"

    email = ClearanceMailer.change_password(user)

    expect(email.body.to_s).to include(link)
  end

  it "sets its subject" do
    user = create(:user)
    user.forgot_password!

    email = ClearanceMailer.change_password(user)

    expect(email.subject).to include("Change your password")
  end

  it "contains opening text in the body" do
    user = create(:user)
    user.forgot_password!

    email = ClearanceMailer.change_password(user)

    expect(email.body).to include(
      I18n.t("clearance_mailer.change_password.opening")
    )
  end

  it "contains closing text in the body" do
    user = create(:user)
    user.forgot_password!

    email = ClearanceMailer.change_password(user)

    expect(email.body.raw_source).to include(
      I18n.t("clearance_mailer.change_password.closing")
    )
  end
end
