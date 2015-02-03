class ClearanceMailer < ActionMailer::Base
  def change_password(password_reset)
    @password_reset = password_reset

    mail(
      from: Clearance.configuration.mailer_sender,
      to: @password_reset.user_email,
      subject: I18n.t(
        :change_password,
        scope: [:clearance, :models, :clearance_mailer],
        default: "Change your password"
      )
    )
  end
end
