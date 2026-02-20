FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password { "password" }

    trait :with_forgotten_password do
      confirmation_token { Clearance::Token.new }
      confirmation_token_created_at { Time.current }
    end

    factory :user_with_optional_password, class: "UserWithOptionalPassword" do
      password { nil }
      encrypted_password { "" }
    end
  end
end
