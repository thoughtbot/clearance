FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password 'password'

    factory :user_with_optional_password, class: 'UserWithOptionalPassword' do
      password nil
      encrypted_password ''
    end

    trait :with_forgotten_password do
      confirmation_token Clearance::Token.new
    end
  end
end
