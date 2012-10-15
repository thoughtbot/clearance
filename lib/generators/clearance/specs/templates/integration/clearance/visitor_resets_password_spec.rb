require 'spec_helper'

feature 'Visitor resets password' do
  scenario 'successfully resets password' do
    user = user_with_reset_password

    page.should have_content('instructions for changing your password')
    reset_notification_should_be_sent_to user
  end

  scenario 'successfully updates password' do
    user = user_with_reset_password
    update_password(user, 'newpassword')

    user_should_be_signed_in
  end

  scenario 'successfully signs in with updated password' do
    user = user_with_reset_password
    update_password(user, 'newpassword')
    sign_out
    sign_in_with(user.email, 'newpassword')

    user_should_be_signed_in
  end

  scenario 'unsuccesful when using a blank password' do
    user = user_with_reset_password
    visit_password_reset_page_for user
    change_password_to ''

    page.should have_content("Password can't be blank")
    user_should_be_signed_out
  end

  scenario 'unsucessful without a user account' do
    reset_password_for 'unknown.email@example.com'

    page.should have_content('instructions for changing your password')
    mailer_should_have_no_deliveries
  end

  private

  def user_with_reset_password
    user = create(:user)
    reset_password_for user.email
    user.reload
  end

  def reset_password_for(email)
    visit new_password_path
    fill_in 'Email address', :with => email
    click_button 'Reset password'
  end

  def update_password(user, password)
    visit_password_reset_page_for user
    change_password_to password
  end

  def visit_password_reset_page_for(user)
    visit edit_user_password_path(
      :user_id => user,
      :token => user.confirmation_token
    )
  end

  def change_password_to(password)
    fill_in 'Choose password', :with => password
    click_button 'Save this password'
  end

  def reset_notification_should_be_sent_to(user)
    user.confirmation_token.should_not be_blank
    mailer_should_have_delivery(user.email, 'password', user.confirmation_token)
  end
end
