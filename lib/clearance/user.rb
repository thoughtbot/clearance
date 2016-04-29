require 'digest/sha1'
require 'active_model'
require 'email_validator'
require 'clearance/token'

module Clearance
  # Required to be included in your configued user class, which is `User` by
  # default, but can be changed with {Configuration#user_model=}.
  #
  #     class User
  #       include Clearance::User
  #
  #       # ...
  #     end
  #
  # This will also include methods exposed by your password strategy, which can
  # be configured with {Configuration#password_strategy=}. By default, this is
  # {PasswordStrategies::BCrypt}.
  #
  # ## Validations
  #
  # These validations are added to the class that the {User} module is mixed
  # into.
  #
  # * If {#email_optional?} is false, {#email} is validated for presence,
  #   uniqueness and email format (using the `email_validator` gem in strict
  #   mode).
  # * If {#skip_password_validation?} is false, {#password} is validated
  #   for presence.
  #
  # ## Callbacks
  #
  # * {#normalize_email} will be called on `before_validation`
  # * {#generate_remember_token} will be called on `before_create`
  #
  # @!attribute email
  #   @return [String] The user's email.
  #
  # @!attribute encrypted_password
  #   @return [String] The user's encrypted password.
  #
  # @!attribute remember_token
  #   @return [String] The value used to identify this user in their {Session}
  #     cookie.
  #
  # @!attribute confirmation_token
  #   @return [String] The value used to identify this user in the password
  #     reset link.
  #
  # @!attribute [r] password
  #   @return [String] Transient (non-persisted) attribute that is set when
  #     updating a user's password. Only the {#encrypted_password} is persisted.
  #
  # @!method password=
  #   Sets the user's encrypted_password by using the configured Password
  #   Strategy's `password=` method. By default, this will be
  #   {PasswordStrategies::BCrypt#password=}, but can be changed with
  #   {Configuration#password_strategy}.
  #
  #   @see PasswordStrategies
  #   @return [void]
  #
  # @!method authenticated?
  #   Check's the provided password against the user's encrypted password using
  #   the configured password strategy. By default, this will be
  #   {PasswordStrategies::BCrypt#authenticated?}, but can be changed with
  #   {Configuration#password_strategy}.
  #
  #   @see PasswordStrategies
  #   @param [String] password
  #     The password to check.
  #   @return [Boolean]
  #     True if the password provided is correct for the user.
  #
  # @!method self.authenticate
  #   Finds the user with the given email and authenticates them with the
  #   provided password. If the email corresponds to a user and the provided
  #   password is correct for that user, this method will return that user.
  #   Otherwise it will return nil.
  #
  #   @return [User, nil]
  #
  # @!method self.find_by_normalized_email
  #   Finds the user with the given email. The email with be normalized via
  #   {#normalize_email}.
  #
  #   @return [User, nil]
  #
  # @!method self.normalize_email
  #   Normalizes the provided email by downcasing and removing all spaces.
  #   This is used by {find_by_normalized_email} and is also called when
  #   validating a user to ensure only normalized emails are stored in the
  #   database.
  #
  #   @return [String]
  #
  module User
    extend ActiveSupport::Concern

    included do
      attr_reader :password

      include Validations
      include Callbacks
      include password_strategy

      def password=(value)
        encrypted_password_will_change!
        super
      end
    end

    # @api private
    module ClassMethods
      def authenticate(email, password)
        if user = find_by_normalized_email(email)
          if password.present? && user.authenticated?(password)
            user
          end
        end
      end

      def find_by_normalized_email(email)
        find_by_email normalize_email(email)
      end

      def normalize_email(email)
        email.to_s.downcase.gsub(/\s+/, "")
      end

      private

      def password_strategy
        Clearance.configuration.password_strategy || PasswordStrategies::BCrypt
      end
    end

    # @api private
    module Validations
      extend ActiveSupport::Concern

      included do
        validates :email,
          email: { strict_mode: true },
          presence: true,
          uniqueness: { allow_blank: true },
          unless: :email_optional?

        validates :password, presence: true, unless: :skip_password_validation?
      end
    end

    # @api private
    module Callbacks
      extend ActiveSupport::Concern

      included do
        before_validation :normalize_email
        before_create :generate_remember_token
      end
    end

    # Generates a {#confirmation_token} for the user, which allows them to reset
    # their password via an email link.
    #
    # Calling `forgot_password!` will cause the user model to be saved without
    # validations. Any other changes you made to this user instance will also
    # be persisted, without validation. It is inteded to be called on an
    # instance with no changes (`dirty? == false`).
    #
    # @return [Boolean] Was the save successful?
    def forgot_password!
      generate_confirmation_token
      save validate: false
    end

    # Generates a new {#remember_token} for the user, which will have the effect
    # of signing all of the user's current sessions out. This is called
    # internally by {Session#sign_out}.
    #
    # Calling `reset_remember_token!` will cause the user model to be saved
    # without validations. Any other changes you made to this user instance will
    # also be persisted, without validation. It is inteded to be called on an
    # instance with no changes (`dirty? == false`).
    #
    # @return [Boolean] Was the save successful?
    def reset_remember_token!
      generate_remember_token
      save validate: false
    end

    # Sets the user's password to the new value, using the `password=` method on
    # the configured password strategy. By default, this is
    # {PasswordStrategies::BCrypt#password=}.
    #
    # This also has the side-effect of blanking the {#confirmation_token} and
    # rotating the `#remember_token`.
    #
    # Validations will be run as part of this update. If the user instance is
    # not valid, the password change will not be persisted, and this method will
    # return `false`.
    #
    # @return [Boolean] Was the save successful?
    def update_password(new_password)
      self.password = new_password

      if valid?
        self.confirmation_token = nil
        generate_remember_token
      end

      save
    end

    private

    # Sets the email on this instance to the value returned by
    # {.normalize_email}
    #
    # @return [String]
    def normalize_email
      self.email = self.class.normalize_email(email)
    end

    # Always false. Override this method in your user model to allow for other
    # forms of user authentication (username, Facebook, etc).
    #
    # @return [false]
    def email_optional?
      false
    end

    # Always false. Override this method in your user model to allow for other
    # forms of user authentication (username, Facebook, etc).
    #
    # @return [false]
    def password_optional?
      false
    end

    # True if {#password_optional?} is true or if the user already has an
    # {#encrypted_password} that is not changing.
    #
    # @return [Boolean]
    def skip_password_validation?
      password_optional? ||
        (encrypted_password.present? && !encrypted_password_changed?)
    end

    # Sets the {#confirmation_token} on the instance to a new value generated by
    # {Token.new}. The change is not automatically persisted. If you would like
    # to generate and save in a single method call, use {#forgot_password!}.
    #
    # @return [String] The new confirmation token
    def generate_confirmation_token
      self.confirmation_token = Clearance::Token.new
    end

    # Sets the {#remember_token} on the instance to a new value generated by
    # {Token.new}. The change is not automatically persisted. If you would like
    # to generate and save in a single method call, use
    # {#reset_remember_token!}.
    #
    # @return [String] The new remember token
    def generate_remember_token
      self.remember_token = Clearance::Token.new
    end

    private_constant :Callbacks, :ClassMethods, :Validations
  end
end
