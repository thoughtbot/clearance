module Clearance
  # Runs as the base {SignInGuard} for all requests, regardless of configured
  # {Configuration#sign_in_guards}.
  class DefaultSignInGuard < SignInGuard
    # Runs the default sign in guard.
    #
    # If there is a value set in the clearance session object, then the guard
    # returns {SuccessStatus}. Otherwise, it returns {FailureStatus} with the
    # message returned by {#default_failure_message}.
    #
    # @return [SuccessStatus, FailureStatus]
    def call
      if session.signed_in?
        success
      else
        failure default_failure_message.html_safe
      end
    end

    # The default failure message pulled from the i18n framework.
    #
    # Will use the value returned from the following i18n keys, in this order:
    #
    # * `controllers.sessions.bad_email_or_password`
    # * `clearance.flashes.failure_after_create`
    #
    # @return [String]
    def default_failure_message
      I18n.t("controllers.sessions.bad_email_or_password",
             default: :'clearance.flashes.failure_after_create')
    end
  end
end
