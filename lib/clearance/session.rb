require 'clearance/default_sign_in_guard'

module Clearance
  # Represents a clearance session, ultimately persisted in
  # `request.env[:clearance]` by {RackSession}.
  class Session
    # @param env The current rack environment
    def initialize(env)
      @env = env
      @current_user = nil
      @cookies = nil
    end

    # Called by {RackSession} to add the Clearance session cookie to a response.
    #
    # @return [void]
    def add_cookie_to_headers(headers)
      if signed_in_with_remember_token?
        Rack::Utils.set_cookie_header!(
          headers,
          remember_token_cookie,
          cookie_options.merge(
            value: current_user.remember_token,
          ),
        )
      end
    end

    # The current user represented by this session.
    #
    # @return [User, nil]
    def current_user
      if remember_token.present?
        @current_user ||= user_from_remember_token(remember_token)
      end

      @current_user
    end

    # Sign the provided user in, if approved by the configured sign in guards.
    # If the sign in guard stack returns {SuccessStatus}, the {#current_user}
    # will be set and then remember token cookie will be set to the user's
    # remember token. If the stack returns {FailureStatus}, {#current_user} will
    # be nil.
    #
    # In either event, the resulting status will be yielded to a provided block,
    # if provided. See {SessionsController#create} for an example of how this
    # can be used.
    #
    # @param [User] user
    # @yieldparam [SuccessStatus,FailureStatus] status Result of the sign in
    #   operation.
    # @return [void]
    def sign_in(user, &block)
      @current_user = user
      status = run_sign_in_stack

      if status.success?
        # Sign in succeeded, and when {RackSession} is run and calls
        # {#add_cookie_to_headers} it will set the cookie with the
        # remember_token for the current_user
      else
        @current_user = nil
      end

      if block_given?
        block.call(status)
      end
    end

    # Invalidates the users remember token and removes the remember token cookie
    # from the store. The invalidation of the remember token causes any other
    # sessions that are signed in from other locations to also be invalidated on
    # their next request. This is because all Clearance sessions for a given
    # user share a remember token.
    #
    # @return [void]
    def sign_out
      if signed_in?
        current_user.reset_remember_token!
      end

      @current_user = nil
      cookies.delete remember_token_cookie, delete_cookie_options
    end

    # True if {#current_user} is set.
    #
    # @return [Boolean]
    def signed_in?
      current_user.present?
    end

    # True if {#current_user} is not set
    #
    # @return [Boolean]
    def signed_out?
      ! signed_in?
    end

    # True if a successful authentication has been performed
    #
    # @return [Boolean]
    def authentication_successful?
      !!@current_user
    end

    private

    # @api private
    def cookies
      @cookies ||= ActionDispatch::Request.new(@env).cookie_jar
    end

    # @api private
    def remember_token
      cookies[remember_token_cookie]
    end

    # @api private
    def remember_token_expires
      expires_configuration.call(cookies)
    end

    # @api private
    def signed_in_with_remember_token?
      current_user&.remember_token
    end

    # @api private
    def remember_token_cookie
      Clearance.configuration.cookie_name.freeze
    end

    # @api private
    def expires_configuration
      Clearance.configuration.cookie_expiration
    end

    # @api private
    def user_from_remember_token(token)
      Clearance.configuration.user_model.where(remember_token: token).first
    end

    # @api private
    def run_sign_in_stack
      @stack ||= initialize_sign_in_guard_stack
      @stack.call
    end

    # @api private
    def initialize_sign_in_guard_stack
      default_guard = DefaultSignInGuard.new(self)
      guards = Clearance.configuration.sign_in_guards

      guards.inject(default_guard) do |stack, guard_class|
        guard_class.to_s.constantize.new(self, stack)
      end
    end

    # @api private
    def cookie_options
      {
        domain: domain,
        expires: remember_token_expires,
        httponly: Clearance.configuration.httponly,
        same_site: Clearance.configuration.same_site,
        path: Clearance.configuration.cookie_path,
        secure: Clearance.configuration.secure_cookie,
        value: remember_token,
      }
    end

    # @api private
    def delete_cookie_options
      Hash.new.tap do |options|
        if configured_cookie_domain
          options[:domain] = configured_cookie_domain
        end
      end
    end

    # @api private
    def domain
      if configured_cookie_domain.respond_to?(:call)
        configured_cookie_domain.call(request_with_env)
      else
        configured_cookie_domain
      end
    end

    # @api private
    def configured_cookie_domain
      Clearance.configuration.cookie_domain
    end

    # @api private
    def request_with_env
      ActionDispatch::Request.new(@env)
    end
  end
end
