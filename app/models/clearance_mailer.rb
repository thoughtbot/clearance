class ClearanceMailer < ActionMailer::Base

  def change_password(user)
    from       Clearance.configuration.mailer_sender
    recipients user.email
    subject    I18n.t(:change_password,
                      :scope   => [:clearance, :models, :clearance_mailer],
                      :default => "Change your password")
    body       :user => user
  end

  def confirmation(user)
    from       Clearance.configuration.mailer_sender
    recipients user.email
    subject    I18n.t(:confirmation,
                      :scope   => [:clearance, :models, :clearance_mailer],
                      :default => "Account confirmation")
    body      :user => user
  end

end
