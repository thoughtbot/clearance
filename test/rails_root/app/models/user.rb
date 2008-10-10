class User < ActiveRecord::Base
  include Clearance::Models::User
end