module Integration
  module ClearanceHelpers
    def sign_up_with(email, password)
      visit sign_up_path
      fill_in 'user_email', :with => email
      fill_in 'user_password', :with => password
      click_button I18n.t('helpers.submit.user.create')
    end

    def sign_in_with(email, password)
      visit sign_in_path
      fill_in 'session_email', :with => email
      fill_in 'session_password', :with => password
      click_button I18n.t('helpers.submit.session.submit')
    end

    def signed_in_user
      password = 'password'
      user = create(:user, :password => password)
      sign_in_with user.email, password
      user
    end

    def user_should_be_signed_in
      visit root_path
      page.should have_content I18n.t('layouts.application.sign_out')
    end

    def sign_out
      click_link I18n.t('layouts.application.sign_out')
    end

    def user_should_be_signed_out
      page.should have_content I18n.t('layouts.application.sign_in')
    end

    def user_with_reset_password
      user = create(:user)
      reset_password_for user.email
      user.reload
    end

    def reset_password_for(email)
      visit new_password_path
      fill_in 'password_email', :with => email
      click_button I18n.t('helpers.submit.password.submit')
    end
  end
end
