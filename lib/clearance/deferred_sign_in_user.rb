require "delegate"

module Clearance
  class DeferredSignInUser < SimpleDelegator
    def initialize(user, password)
      @password = password
      super user
    end

    # This method overrides ActiveSupport's present? method, and only returns
    # true if the delegated user is present AND signed in. It has special
    # domain meaning and allows Clearance::Session#signed_in? to work
    # transparently with the defer_sign_in_password_check feature.
    #
    # @return [Boolean]
    def present?
      __getobj__.present? && signed_in?
    end

    # This is the opposite of our custom present? implementation.
    #
    # @return [Boolean]
    def blank?
      !present?
    end

    # This method overrides Kernel#nil? and only returns true if the delegated
    # user is nil.
    #
    # It is part of the defer_sign_in_password_check feature, and should be
    # used by client code to evaluate whether the delegated user is nil, which
    # probably means the user does not exist in the database.
    #
    # @return [Boolean]
    def nil?
      __getobj__.nil?
    end

    # Returns whether this is a deferred_sign_in_user, which it is. Can be used
    # polymorphically with a regular user object.
    #
    # @return [Boolean]
    def deferred_sign_in_user?
      true
    end

    private

    # @api private
    def signed_in?
      return @signed_in unless @signed_in.nil?

      @signed_in = authenticated?(@password)
    end
  end
end
