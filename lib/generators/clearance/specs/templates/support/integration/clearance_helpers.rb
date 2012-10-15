module Integration
  module ClearanceHelpers
    def sign_up_with(email, password)
      visit sign_up_path
      fill_in 'Email', :with => email
      fill_in 'Password', :with => password
      click_button 'Sign up'
    end

    def signed_in_user
      user = FactoryGirl.create(:user)
      sign_in_as user
      user.reload
    end

    def sign_in_as(user)
      sign_in_with(user.email, user.password)
    end

    def sign_in_with(email, password)
      visit sign_in_path
      fill_in 'Email', :with => email
      fill_in 'Password', :with => password
      click_button 'Sign in'
    end

    def sign_out
      click_link 'Sign out'
    end

    def user_should_be_signed_in
      visit root_path
      page.should have_content 'Sign out'
    end

    def user_should_be_signed_out
      page.should have_content 'Sign in'
    end
  end
end
