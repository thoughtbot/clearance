class Mailer < ActionMailer::Base
  
  default_url_options[:host] = HOST
  
  def change_password(user)
    from       "donotreply@example.com"
    recipients user.email
    subject    "[YOUR APP] Request to change your password"
    body       :user => user
  end

end
