Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |user|
  user.email { Factory.next :email }
  user.password "password"
  user.password_confirmation "password"
end
