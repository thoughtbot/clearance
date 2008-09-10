Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |user|
  user.email { Factory.next :email }
  user.password 'sekrit'
  user.password_confirmation 'sekrit'
end
