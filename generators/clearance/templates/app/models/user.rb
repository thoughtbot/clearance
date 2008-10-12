class User < ActiveRecord::Base
  include Clearance::App::Models::User
end