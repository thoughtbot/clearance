class UserMailer < ActionMailer::Base
  
  default_url_options[:host] = HOST
  
  include Clearance::Mailers::User

end
