module Clearance
  module Authentication
    extend ActiveSupport::Concern

    included do
      helper_method :current_user, :signed_in?, :signed_out?
      hide_action(
        :current_user,
        :current_user=,
        :sign_in,
        :sign_out,
        :signed_in?,
        :signed_out?
      )
    end

    def authenticate(params)
      Clearance.configuration.user_model.authenticate(
        params[:session][:email], params[:session][:password]
      )
    end

    def current_user
      if !request.ssl? && Clearance.configuration.secure_cookie
        raise <<-ERROR.strip_heredoc
          Clearance has `secure_cookie` enabled in this environment but
          `current_user` was just accessed during a non-SSL request. Assuming
          this is a live environment, you probably want to set `force_ssl` to
          true in your environment configuration or otherwise force HTTPS
          connections.
        ERROR
      end

      clearance_session.current_user
    end

    def current_user=(user)
      warn "#{Kernel.caller.first}: [DEPRECATION] " +
        'Assigning the current_user has been deprecated. Use the sign_in method instead.'
      clearance_session.sign_in user
    end

    def sign_in(user, &block)
      clearance_session.sign_in user, &block
    end

    def sign_out
      clearance_session.sign_out
    end

    def signed_in?
      clearance_session.signed_in?
    end

    def signed_out?
      !signed_in?
    end

    # CSRF protection in Rails >= 3.0.4
    # http://weblog.rubyonrails.org/2011/2/8/csrf-protection-bypass-in-ruby-on-rails
    def handle_unverified_request
      super
      sign_out
    end

    protected

    def clearance_session
      request.env[:clearance]
    end
  end
end
