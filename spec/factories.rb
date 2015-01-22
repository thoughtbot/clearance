FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password 'password'

    trait :with_forgotten_password do
      confirmation_token Clearance::Token.new
    end

    factory :user_with_optional_password, class: 'UserWithOptionalPassword' do
      password nil
      encrypted_password ''
    end
  end

  factory :password_reset do
    user
  end
end
