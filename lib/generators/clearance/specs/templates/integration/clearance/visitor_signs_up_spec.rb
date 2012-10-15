require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'successful with valid data' do
    sign_up_with 'valid@example.com', 'password'

    user_should_be_signed_in
  end

  scenario 'unsuccessful with a invalid email' do
    sign_up_with 'invalid_email', 'password'

    user_should_be_signed_out
  end

  scenario 'unsuccessful with a blank password' do
    sign_up_with 'valid@example.com', ''

    user_should_be_signed_out
  end
end
