require "spec_helper"

feature "Visitor resets password" do
  scenario "by navigating to the page" do
    visit sign_in_path

    click_link I18n.t("sessions.form.forgot_password")

    expect(current_path).to eq new_password_path
  end

  scenario "with valid email" do
    user = user_with_reset_password

    page_should_display_change_password_message
    reset_notification_should_be_sent_to user
  end

  scenario "with non-user account" do
    reset_password_for "unknown.email@example.com"

    page_should_display_change_password_message
    mailer_should_have_no_deliveries
  end

  private

  def reset_notification_should_be_sent_to(user)
    expect(user.confirmation_token).not_to be_blank
    mailer_should_have_delivery user.email, "password", user.confirmation_token
  end

  def page_should_display_change_password_message
    expect(page).to have_content I18n.t("passwords.create.description")
  end

  def mailer_should_have_delivery(recipient, subject, body)
    expect(ActionMailer::Base.deliveries).not_to be_empty

    message = ActionMailer::Base.deliveries.any? do |email|
      email.to == [recipient] &&
        email.subject =~ /#{subject}/i &&
        email.body =~ /#{body}/
    end

    expect(message).to be
  end

  def mailer_should_have_no_deliveries
    expect(ActionMailer::Base.deliveries).to be_empty
  end
end
