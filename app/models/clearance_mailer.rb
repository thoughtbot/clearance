class ClearanceMailer < ActionMailer::Base

  def change_password(user)
    @user = user
    from       Clearance.configuration.mailer_sender
    recipients @user.email
    subject    I18n.t(:change_password,
                      :scope   => [:clearance, :models, :clearance_mailer],
                      :default => "Change your password")
  end

  def confirmation(user)
    @user = user
    from       Clearance.configuration.mailer_sender
    recipients @user.email
    subject    I18n.t(:confirmation,
                      :scope   => [:clearance, :models, :clearance_mailer],
                      :default => "Account confirmation")
  end

end
