# General

Then /^I should see error messages$/ do
  Then %{I should see "error(s)? prohibited"}
end

# DB

Given /^there is no user with "(.*)"$/ do |email|
  assert_nil User.find_by_email(email)
end

Given /^I signed up with "(.*)\/(.*)"$/ do |email, password|
  user = Factory :registered_user, 
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
  assert_not_nil request.session[:salt]
end

Then /^I should not be signed in$/ do
  assert_nil request.session[:user_id]
  assert_nil request.session[:salt]
end

When /^session is cleared$/ do
  request.session[:user_id] = nil
  request.session[:salt]    = nil
end

# Emails

Then /^a confirmation message should be sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  sent = ActionMailer::Base.deliveries.first
  assert_equal [user.email], sent.to
  assert_equal 'Account confirmation', sent.subject
  assert !user.salt.blank?
  assert_match /#{user.salt}/, sent.body
end

When /^I follow the confirmation link sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  visit new_user_confirmation_path(:user_id => user, :salt => user.salt)
end

# Actions

When /^I sign in( with "remember me")? as "(.*)\/(.*)"$/ do |remember, email, password|
  When %{I go to the signin page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I check "Remember me"} if remember
  And %{I press "Sign In"}
end

When /^I sign out$/ do
  visit '/session', :delete    
end

When /^I return next time$/ do
  When %{session is cleared}
  And %{I go to the homepage}
end
