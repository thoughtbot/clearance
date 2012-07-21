# Existing users

require 'factory_girl_rails'

Given /^(?:I am|I have|I) signed up (?:as|with) "(.*)"$/ do |email|
  FactoryGirl.create :user, :email => email
end

Given /^a user "([^"]*)" exists without a remember token or password$/ do |email|
  user = FactoryGirl.create(:user, :email => email)
  sql  = "update users set encrypted_password = NULL, remember_token = NULL where id = #{user.id}"
  ActiveRecord::Base.connection.update sql
end

# Sign up

When /^I sign up (?:with|as) "(.*)" and "(.*)"$/ do |email, password|
  visit sign_up_path
  page.should have_css("input[type='email']")
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  click_button 'Sign up'
end

# Sign in

Given /^I sign in$/ do
  email = FactoryGirl.generate(:email)
  steps %{
    Given I have signed up with "#{email}"
    And I sign in with "#{email}"
  }
end

When /^I sign in (?:with|as) "([^"]*)"$/ do |email|
  step %{I sign in with "#{email}" and "password"}
end

When /^I sign in (?:with|as) "([^"]*)" and "([^"]*)"$/ do |email, password|
  visit sign_in_path
  page.should have_css("input[type='email']")
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  click_button 'Sign in'
end

# Sign out

When "I sign out" do
  visit '/'
  click_link 'Sign out'
end

# Reset password

When /^I reset the password for "(.*)"$/ do |email|
  visit new_password_path
  page.should have_css("input[type='email']")
  fill_in 'Email address', :with => email
  click_button 'Reset password'
end

Then /^instructions for changing my password are emailed to "(.*)"$/ do |email|
  page.should have_content('instructions for changing your password')
  user = User.find_by_email!(email)
  assert !user.confirmation_token.blank?
  assert !ActionMailer::Base.deliveries.empty?

  result = ActionMailer::Base.deliveries.any? do |email|
    email.to == [user.email] &&
    email.subject =~ /password/i &&
    email.body =~ /#{user.confirmation_token}/
  end

  assert result
end

When /^I follow the password reset link sent to "(.*)"$/ do |email|
  user = User.find_by_email!(email)
  visit edit_user_password_path(:user_id => user,
                                :token   => user.confirmation_token)
end

When /^I change the password of "(.*)" without token$/ do |email|
  user = User.find_by_email!(email)
  visit edit_user_password_path(:user_id => user)
end

When /^I update my password with "(.*)"$/ do |password|
  fill_in 'Choose password', :with => password
  click_button 'Save this password'
end

# Navigation

Then /^I should be on the sign up page$/ do
  page.current_path.should == sign_up_path
end

# Flashes

Then /^I am told email or password is bad$/ do
  page.should have_content('Bad email or password. Are you trying to register a new account? Sign up.')
end

When /^I follow the sign up link in the flash$/ do
  within '#flash' do
    click_link 'Sign up'
  end
end

Then /^I am told email is unknown$/ do
  page.should have_content('Unknown email')
end

Then /^I am told to enter a valid email address$/ do
  page.should have_content('Must be a valid email address')
end

Then /^I am told to enter a password$/ do
  page.should have_content("Password can't be blank")
end

# Verification

Then /^I should be signed in$/ do
  visit '/'
  page.should have_content 'Sign out'
end

Then /^I should be signed out$/ do
  visit '/'
  page.should have_content 'Sign in'
end
