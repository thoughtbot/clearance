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
    allow(Clearance.configuration).to receive(:password_reset_time_limit).
      and_return(10.minutes)

    email = ClearanceMailer.change_password(password_reset)

    expect(email.body.parts.length).to eq 2
    expect(email.text_part).to be_present
    expect(email.html_part).to be_present
  end

  it "contains a link to edit the password" do
    password_reset = create(:password_reset)
    host = ActionMailer::Base.default_url_options[:host]
    link = "http://#{host}/users/#{password_reset.user_id}/password/edit" \
      "?token=#{password_reset.token}"
    allow(PasswordReset).to receive(:time_limit).and_return(10.minutes)

    email = ClearanceMailer.change_password(password_reset)

    expect(email.text_part.body).to include(link)
    expect(email.html_part.body).to include(link)
    expect(email.html_part.body).to have_css(
      "a",
      text: I18n.t("clearance_mailer.change_password.link_text")
    )
    expect(email.text_part.body).to include(expiration_warning("10 minutes"))
    expect(email.html_part.body).to include(expiration_warning("10 minutes"))
  end

  def expiration_warning(duration)
    I18n.t("clearance_mailer.change_password.opening", time_limit: duration)
  end
end
