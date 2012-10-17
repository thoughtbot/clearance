require 'spec_helper'

feature 'Visitor resets password' do
  scenario 'with valid email' do
    user = user_with_reset_password

    page_should_display_change_password_message
    reset_notification_should_be_sent_to user
  end

  scenario 'with non-user account' do
    reset_password_for 'unknown.email@example.com'

    page_should_display_change_password_message
    mailer_should_have_no_deliveries
  end

  private

  def reset_notification_should_be_sent_to(user)
    user.confirmation_token.should_not be_blank
    mailer_should_have_delivery user.email, 'password', user.confirmation_token
  end

  def page_should_display_change_password_message
    page.should have_content I18n.t('passwords.create.description')
  end
end
