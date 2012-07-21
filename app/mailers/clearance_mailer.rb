class ClearanceMailer < ActionMailer::Base
  def change_password(user)
    @user = user
    mail :from => Clearance.configuration.mailer_sender, :to => @user.email,
      :subject => I18n.t(:change_password,
         :scope => [:clearance, :models, :clearance_mailer],
         :default => 'Change your password')
  end
end
