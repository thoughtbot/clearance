module Clearance
  class DefaultSignInGuard < SignInGuard
    def call
      if session.signed_in?
        success
      else
        failure default_failure_message.html_safe
      end
    end

    def default_failure_message
      I18n.t(
        :bad_email_or_password,
        scope: [:clearance, :controllers, :sessions],
        default: I18n.t('flashes.failure_after_create').html_safe
      )
    end
  end
end
