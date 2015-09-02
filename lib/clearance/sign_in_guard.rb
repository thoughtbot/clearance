require 'clearance/session_status'

module Clearance
  # The base class for {DefaultSignInGuard} and all custom sign in guards.
  #
  # Sign in guards provide you with fine-grained control over the process of
  # signing in a user. Each guard is run in order and can do one of the
  # following:
  #
  # * Fail the sign in process
  # * Call the next guard in the stack
  # * Short circuit all remaining guards, declaring sign in successfull.
  #
  # Sign In Guards could be used, for instance, to require that a user confirm
  # their email address before being allowed to sign in.
  #
  #     # in config/initializers/clearance.rb
  #     Clearance.configure do |config|
  #       config.sign_in_guards = [ConfirmationGuard]
  #     end
  #
  #     # in lib/guards/confirmation_guard.rb
  #     class ConfirmationGuard < Clearance::SignInGuard
  #       def call
  #         if signed_in? && current_user.email_confirmed?
  #           next_guard
  #         else
  #           failure("You must confirm your email address.")
  #         end
  #       end
  #     end
  #
  # Calling `success` or `failure` in any guard short circuits all of the
  # remaining guards in the stack. In most cases, you will want to either call
  # `failure` or `next_guard`. The {DefaultSignInGuard} will always be the final
  # guard called and will handle calling `success` if appropriate.
  #
  # The stack is designed such that calling `call` will eventually return
  # {SuccessStatus} or {FailureStatus}, thus halting the chain.
  class SignInGuard
    # Creates an instance of a sign in guard.
    #
    # This is called by {Session} automatically using the array of guards
    # configured in {Configuration#sign_in_guards} and the {DefaultSignInGuard}.
    # There is no reason for users of Clearance to concern themselves with the
    # initialization of each guard or the stack as a whole.
    #
    # @param [Session] session The current clearance session
    # @param [[SignInGuard]] stack The sign in guards that come after this
    #   guard in the stack
    def initialize(session, stack = [])
      @session = session
      @stack = stack
    end

    # Indicates the entire sign in operation is successful and that no further
    # guards should be run.
    #
    # In most cases your guards will want to delegate this responsibility to the
    # {DefaultSignInGuard}, allowing the entire stack to execute. In that case,
    # your custom guard would likely want to call `next_guard` instead.
    #
    # @return [SuccessStatus]
    def success
      SuccessStatus.new
    end

    # Indicates this guard failed, and the entire sign in process should fail as
    # a result.
    #
    # @param [String] message The reason the guard failed.
    # @return [FailureStatus]
    def failure(message)
      FailureStatus.new(message)
    end

    # Passes off responsibility for determining success or failure to the next
    # guard in the stack.
    #
    # @return [SuccessStatus, FailureStatus]
    def next_guard
      stack.call
    end

    private

    attr_reader :stack, :session

    # True if there is a currently a user stored in the clearance environment.
    def signed_in?
      session.signed_in?
    end

    # The user currently stored in the clearance environment.
    def current_user
      session.current_user
    end
  end
end
