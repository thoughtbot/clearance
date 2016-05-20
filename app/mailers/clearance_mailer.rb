class ClearanceMailer < ActionMailer::Base
  def change_password(user)
    @user = user
    @token = generate_password_reset_token(@user)

    mail(
      from: Clearance.configuration.mailer_sender,
      to: @user.email,
      subject: I18n.t(
        :change_password,
        scope: [:clearance, :models, :clearance_mailer]
      ),
    )
  end

  private

  def generate_password_reset_token(user)
    Clearance::PasswordResetToken.generate_for(user)
  end
end
