require "spec_helper"

describe Clearance::Mailer do
  it "is from DO_NOT_REPLY" do
    user = create(:user)
    user.forgot_password!

    email = Clearance::Mailer.change_password(user)

    expect(Clearance.configuration.mailer_sender).to eq(email.from[0])
  end

  it "is sent to user" do
    user = create(:user)
    user.forgot_password!

    email = Clearance::Mailer.change_password(user)

    expect(email.to.first).to eq(user.email)
  end

  it "sets its subject" do
    user = create(:user)
    user.forgot_password!

    email = Clearance::Mailer.change_password(user)

    expect(email.subject).to include("Change your password")
  end

  it "has html and plain text parts" do
    user = create(:user)
    user.forgot_password!

    email = Clearance::Mailer.change_password(user)

    expect(email.body.parts.length).to eq 2
    expect(email.text_part).to be_present
    expect(email.html_part).to be_present
  end

  it "contains a link to edit the password" do
    user = create(:user)
    user.forgot_password!
    host = ActionMailer::Base.default_url_options[:host]
    link = "http://#{host}/users/#{user.id}/password/edit" \
      "?token=#{user.confirmation_token}"

    email = Clearance::Mailer.change_password(user)

    expect(email.text_part.body).to include(link)
    expect(email.html_part.body).to include(link)
    expect(email.html_part.body).to have_css(
      "a",
      text: I18n.t("clearance.mailer.change_password.link_text")
    )
  end

  it "has a top-level alias for backwards compatibility" do
    expect(Kernel).to be_const_defined :ClearanceMailer
    expect(::ClearanceMailer).to eq described_class
  end
end
