require 'spec_helper'

feature 'Visitor updates password' do
  scenario 'with valid password' do
    user = user_with_reset_password
    update_password user, 'newpassword'

    user_should_be_signed_in
  end

  scenario 'signs in with new password' do
    user = user_with_reset_password
    update_password user, 'newpassword'
    sign_out
    sign_in_with user.email, 'newpassword'

    user_should_be_signed_in
  end

  scenario 'tries with a blank password' do
    user = user_with_reset_password
    visit_password_reset_page_for user
    change_password_to ''

    page.should have_content I18n.t('flashes.failure_after_update')
    user_should_be_signed_out
  end

  private

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
    fill_in 'password_reset_password', :with => password
    click_button I18n.t('helpers.submit.password_reset.submit')
  end
end
