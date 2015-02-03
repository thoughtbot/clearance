require "spec_helper"

describe ClearanceMailer do
  it "is from DO_NOT_REPLY" do
    password_reset = create(:password_reset)

    email = ClearanceMailer.change_password(password_reset)

    expect(Clearance.configuration.mailer_sender).to eq(email.from[0])
  end

  it "is sent to user" do
    password_reset = create(:password_reset)

    email = ClearanceMailer.change_password(password_reset)

    expect(email.to.first).to eq(password_reset.user_email)
  end

  it "sets its subject" do
    password_reset = create(:password_reset)

    email = ClearanceMailer.change_password(password_reset)

    expect(email.subject).to include("Change your password")
  end

  it "has html and plain text parts" do
    password_reset = create(:password_reset)

    email = ClearanceMailer.change_password(password_reset)

    expect(email.body.parts.length).to eq 2
    expect(email.text_part).to be_present
    expect(email.html_part).to be_present
  end

  it "contains a link to edit the password" do
    password_reset = create(:password_reset)
    user = password_reset.user
    host = ActionMailer::Base.default_url_options[:host]
    link = "http://#{host}/users/#{user.id}/password/edit" \
      "?token=#{user.confirmation_token}"

    email = ClearanceMailer.change_password(password_reset)

    expect(email.text_part.body).to include(link)
    expect(email.html_part.body).to include(link)
    expect(email.html_part.body).to have_css(
      "a",
      text: I18n.t("clearance_mailer.change_password.link_text")
    )
  end
end
