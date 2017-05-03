class Clearance::Mailer < ActionMailer::Base
  def change_password(user)
    @user = user
    mail(
      from: Clearance.configuration.mailer_sender,
      to: @user.email
    )
  end
end

# for backwards compatibility
ClearanceMailer = Clearance::Mailer
