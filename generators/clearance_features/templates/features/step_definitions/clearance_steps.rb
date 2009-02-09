# General

Then /^I should see error messages$/ do
  Then %{I should see "error(s)? prohibited"}
end

# DB

Given /^there is no user with "(.*)"$/ do |email|
  assert_nil User.find_by_email(email)
end

Given /^I signed up with "(.*)\/(.*)"$/ do |email, password|
  user = Factory :user, 
    :email                 => email, 
    :password              => password,
    :password_confirmation => password
end 

Given /^I am signed up and confirmed as "(.*)\/(.*)"$/ do |email, password|
  user = Factory :email_confirmed_user,
    :email                 => email, 
    :password              => password,
    :password_confirmation => password
end

# Session

Then /^I should be signed in$/ do
  assert_not_nil request.session[:user_id]
end

Then /^I should not be signed in$/ do
  assert_nil request.session[:user_id]
end

When /^session is cleared$/ do
  request.session[:user_id] = nil
end

# Emails

Then /^a confirmation message should be sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  sent = ActionMailer::Base.deliveries.first
  assert_equal [user.email], sent.to
  assert_equal 'Account confirmation', sent.subject
  assert !user.token.blank?
  assert_match /#{user.token}/, sent.body
end

When /^I follow the confirmation link sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  visit new_user_confirmation_path(:user_id => user, :token => user.token)
end

Then /^a password reset message should be sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  sent = ActionMailer::Base.deliveries.first
  assert_equal [user.email], sent.to
  assert_equal 'Change your password', sent.subject
  assert !user.token.blank?
  assert_match /#{user.token}/, sent.body
end

When /^I follow the password reset link sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  visit edit_user_password_path(:user_id => user, :token => user.token)
end

# Actions

When /^I sign in( with "remember me")? as "(.*)\/(.*)"$/ do |remember, email, password|
  When %{I go to the sign in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I check "Remember me"} if remember
  And %{I press "Sign In"}
end

When /^I sign out$/ do
  visit '/session', :delete    
end

When /^I request password reset link to be sent to "(.*)"$/ do |email|
  When %{I go to the password reset request page}
  And %{I fill in "Email address" with "#{email}"}
  And %{I press "Reset password"}
end

When /^I update my password with "(.*)\/(.*)"$/ do |password, confirmation|
  And %{I fill in "Choose password" with "#{password}"}
  And %{I fill in "Verify password" with "#{confirmation}"}
  And %{I press "Save this password"}   
end

When /^I return next time$/ do
  When %{session is cleared}
  And %{I go to the homepage}
end
