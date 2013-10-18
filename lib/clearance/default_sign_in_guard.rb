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
      I18n.t("flashes.failure_after_create", :sign_up_path => sign_up_path)
    end

    def sign_up_path
      Rails.application.routes.url_helpers.sign_up_path
    end
  end
end
