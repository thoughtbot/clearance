module Clearance
  module Authentication
    extend ActiveSupport::Concern

    included do
      if respond_to?(:helper_method)
        helper_method :current_user, :signed_in?, :signed_out?
      end

      private(
        :authenticate,
        :current_user,
        :handle_unverified_request,
        :sign_in,
        :sign_out,
        :signed_in?,
        :signed_out?
      )
    end

    # Authenticate a user with a provided email and password
    # @param [ActionController::Parameters] params The parameters from the
    #   sign in form. `params[:session][:email]` and
    #   `params[:session][:password]` are required.
    # @return [User, nil] The user or nil if authentication fails.
    def authenticate(params)
      Clearance.configuration.user_model.authenticate(
        params[:session][:email], params[:session][:password]
      )
    end

    # Get the user from the current clearance session. Exposed as a
    # `helper_method`, making it visible to views. Prefer {#signed_in?} or
    # {#signed_out?} if you only want to check for the presence of a current
    # user rather than access the actual user.
    #
    # @return [User, nil] The user if one is signed in or nil otherwise.
    def current_user
      clearance_session.current_user
    end

    # Sign in the provided user.
    # @param [User] user
    #
    # Signing in will run the stack of {Configuration#sign_in_guards}.
    #
    # You can provide a block to this method to handle the result of that stack.
    # Your block will receive either a {SuccessStatus} or {FailureStatus}
    #
    #     sign_in(user) do |status|
    #       if status.success?
    #         # ...
    #       else
    #         # ...
    #       end
    #     end
    #
    # For an example of how clearance uses this internally, see
    # {SessionsController#create}.
    #
    # Signing in will also regenerate the CSRF token for the current session,
    # provided {Configuration#rotate_csrf_token_on_sign_in} is set.
    def sign_in(user, &block)
      clearance_session.sign_in(user, &block)

      if signed_in? && Clearance.configuration.rotate_csrf_on_sign_in?
        session.delete(:_csrf_token)
        form_authenticity_token
      end
    end

    # Destroy the current user's Clearance session.
    # See {Session#sign_out} for specifics.
    def sign_out
      clearance_session.sign_out
    end

    # True if there is a currently-signed-in user. Exposed as a `helper_method`,
    # making it available to views.
    #
    # Using `signed_in?` is preferable to checking {#current_user} against nil
    # as it will allow you to introduce a null user object more simply at a
    # later date.
    #
    # @return [Boolean]
    def signed_in?
      clearance_session.signed_in?
    end

    # True if there is no currently-signed-in user. Exposed as a
    # `helper_method`, making it available to views.
    #
    # Usings `signed_out?` is preferable to checking for presence of
    # {#current_user} as it will allow you to introduce a null user object more
    # simply at a later date.
    def signed_out?
      !signed_in?
    end

    # CSRF protection in Rails >= 3.0.4
    #
    # http://weblog.rubyonrails.org/2011/2/8/csrf-protection-bypass-in-ruby-on-rails
    # @private
    def handle_unverified_request
      super
      sign_out
    end

    protected

    # @api private
    def clearance_session
      request.env[:clearance]
    end
  end
end
