# General

Then /^I should see error messages$/ do
  Then %{I should see "errors prohibited"}
end

Then /^I should see an error message$/ do
  Then %{I should see "error prohibited"}
end

Then /^I should see an email field$/ do
  if page.respond_to?(:should)
    page.should have_css("input[type='email']")
  else
    assert page.has_css("input[type='email']")
  end
end

# Database

Given /^no user exists with an email of "(.*)"$/ do |email|
  assert_nil User.find_by_email(email)
end

Given /^(?:I am|I have|I) signed up (?:as|with) "(.*)\/(.*)"$/ do |email, password|
  Factory(:user,
          :email    => email,
          :password => password)
end

Given /^a user "([^"]*)" exists without a salt, remember token, or password$/ do |email|
  user = Factory(:user, :email => email)
  sql  = "update users set salt = NULL, encrypted_password = NULL, remember_token = NULL where id = #{user.id}"
  ActiveRecord::Base.connection.update(sql)
end

# Session

Then /^I should be signed in$/ do
  Given %{I am on the homepage}
  Then %{I should see "Sign out"}
end

Then /^I should be signed out$/ do
  Given %{I am on the homepage}
  Then %{I should see "Sign in"}
end

When /^session is cleared$/ do
  # TODO: This doesn't work with Capybara
  # TODO: I tried Capybara.reset_sessions! but that didn't work
  #request.reset_session
  #controller.instance_variable_set(:@_current_user, nil)
end

Given /^(?:I am|I have|I) signed in (?:with|as) "(.*)\/(.*)"$/ do |email, password|
  Given %{I am signed up as "#{email}/#{password}"}
  And %{I sign in as "#{email}/#{password}"}
end

Given /^I sign in$/ do
  email = Factory.next(:email)
  Given %{I have signed in with "#{email}/password"}
end

# Emails

Then /^a password reset message should be sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  assert !user.confirmation_token.blank?
  assert !ActionMailer::Base.deliveries.empty?
  result = ActionMailer::Base.deliveries.any? do |email|
    email.to      == [user.email] &&
    email.subject =~ /password/i &&
    email.body    =~ /#{user.confirmation_token}/
  end
  assert result
end

When /^I follow the password reset link sent to "(.*)"$/ do |email|
  user = User.find_by_email(email)
  visit edit_user_password_path(:user_id => user,
                                :token   => user.confirmation_token)
end

When /^I try to change the password of "(.*)" without token$/ do |email|
  user = User.find_by_email(email)
  visit edit_user_password_path(:user_id => user)
end

# Actions

When /^I sign in (?:with|as) "(.*)\/(.*)"$/ do |email, password|
  When %{I go to the sign in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Sign in"}
end

When "I sign out" do
  steps %{
    When I go to the homepage
    And I follow "Sign out"
  }
end

When /^I request password reset link to be sent to "(.*)"$/ do |email|
  When %{I go to the password reset request page}
  And %{I fill in "Email address" with "#{email}"}
  And %{I press "Reset password"}
end

When /^I update my password with "(.*)"$/ do |password|
  And %{I fill in "Choose password" with "#{password}"}
  And %{I press "Save this password"}
end

When /^I return next time$/ do
  When %{session is cleared}
  And %{I go to the homepage}
end
