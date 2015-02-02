FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password 'password'

    trait :with_forgotten_password do
      after(:create) do |user|
        create(:password_reset, user_id: user.id)
      end
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
