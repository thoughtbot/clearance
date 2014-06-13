class ClearanceMailer < ActionMailer::Base
  default from: Clearance.config.mailer_sender

  def change_password(password_reset)
    @password_reset = password_reset
    mail(to: @password_reset.email)
  end
end
