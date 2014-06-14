FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }

  factory :user do
    email
    password_digest "password"
  end

  factory :password_reset, class: Clearance::PasswordReset do
    user
  end
end
