class Person < ActiveRecord::Base
  include Clearance::User
end
