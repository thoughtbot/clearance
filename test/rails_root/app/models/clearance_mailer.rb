class ClearanceMailer < ActionMailer::Base
  default_url_options[:host] = HOST
  
  include Clearance::App::Models::ClearanceMailer
end
