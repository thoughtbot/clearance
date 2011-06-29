Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |factory|
  factory.email    { Factory.next :email }
  factory.password { "password" }
end

Factory.define :email_confirmed_user, :parent => :user do |factory|
  factory.after_build { warn "[DEPRECATION] The :email_confirmed_user factory is deprecated, please use the :user factory instead." }
end
