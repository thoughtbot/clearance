require 'spec_helper'

feature 'Visitor signs in' do
  scenario 'successful with valid email and password' do
    user = create(:user, :email => 'user@example.com', :password => 'password')
    sign_in_with 'user@example.com', 'password'

    user_should_be_signed_in
  end

  scenario 'successful with valid uppercase email and password ' do
    user = create(:user, :email => 'user@example.com', :password => 'password')
    sign_in_with 'USER@example.com', 'password'

    user_should_be_signed_in
  end

  scenario 'unsuccessful without a user account' do
    sign_in_with 'unknown.email@example.com', 'password'

    page.should have_content('Bad email or password')
    user_should_be_signed_out
  end

  scenario 'unsuccessful with valid email and invalid password' do
    user = create(:user, password: 'password')
    sign_in_with user.email, 'wrong_password'

    page.should have_content('Bad email or password')
    user_should_be_signed_out
  end
 end
