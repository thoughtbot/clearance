module Integration
  module ClearanceHelpers
    def sign_up_with(email, password)
      visit sign_up_path
      fill_in 'Email', :with => email
      fill_in 'Password', :with => password
      click_button 'Sign up'
    end

    def sign_in_with(email, password)
      visit sign_in_path
      fill_in 'Email', :with => email
      fill_in 'Password', :with => password
      click_button 'Sign in'
    end

    def signed_in_user
      password = 'password'
      user = create(:user, :password => password)
      sign_in_with user.email, password
      user
    end

    def user_should_be_signed_in
      visit root_path
      page.should have_content('Sign out')
    end

    def sign_out
      click_link 'Sign out'
    end

    def user_should_be_signed_out
      page.should have_content('Sign in')
    end

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
  end
end
