require 'digest/sha1'

module Clearance
  module User
    extend ActiveSupport::Concern

    # Hook for all Clearance::User modules.
    #
    # If you need to override parts of Clearance::User,
    # extend and include à la carte.
    #
    # @example
    #   include Clearance::User::Callbacks
    #
    # @see Validations
    # @see Callbacks
    included do
      attr_accessor :password_changing
      attr_reader   :password

      include Validations
      include Callbacks

      include (Clearance.configuration.password_strategy || Clearance::PasswordStrategies::BCrypt)
    end

    module ClassMethods
      # Authenticate with email and password.
      #
      # @param [String, String] email and password
      # @return [User, nil] authenticated user or nil
      # @example
      #   User.authenticate("email@example.com", "password")
      def authenticate(email, password)
        return nil  unless user = find_by_email(email.to_s.downcase)
        return user if     user.authenticated?(password)
      end
    end

    module Validations
      extend ActiveSupport::Concern

      # Hook for validations.
      #
      # :email must be present, unique, formatted
      #
      # If password is required,
      # :password must be present, confirmed
      included do
        validates_presence_of     :email, :unless => :email_optional?
        validates_uniqueness_of   :email, :allow_blank => true
        validates_format_of       :email, :with => %r{^[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$}i, :allow_blank => true

        validates_presence_of     :password, :unless => :password_optional?
      end
    end

    module Callbacks
      extend ActiveSupport::Concern

      # Hook for callbacks.
      #
      # salt, token, password encryption are handled before_save.
      included do
        before_validation :downcase_email
        before_create     :generate_remember_token
      end
    end

    # Set the remember token.
    #
    # @deprecated Use {#reset_remember_token!} instead
    def remember_me!
      warn "[DEPRECATION] remember_me!: use reset_remember_token! instead"
      reset_remember_token!
    end

    # Reset the remember token.
    #
    # @example
    #   user.reset_remember_token!
    def reset_remember_token!
      generate_remember_token
      save(:validate => false)
    end

    # Mark my account as forgotten password.
    #
    # @example
    #   user.forgot_password!
    def forgot_password!
      generate_confirmation_token
      save(:validate => false)
    end

    # Update my password.
    #
    # @return [true, false] password was updated or not
    # @example
    #   user.update_password('new-password')
    def update_password(new_password)
      self.password_changing = true
      self.password          = new_password
      if valid?
        self.confirmation_token = nil
        generate_remember_token
      end
      save
    end

    private

    def generate_random_code(length = 20)
      if RUBY_VERSION >= '1.9'
        SecureRandom.hex(length).encode('UTF-8')
      else
        SecureRandom.hex(length)
      end
    end

    def generate_remember_token
      self.remember_token = generate_random_code
    end

    def generate_confirmation_token
      self.confirmation_token = generate_random_code
    end

    # Always false. Override to allow other forms of authentication
    # (username, facebook, etc).
    # @return [Boolean] true if the email field be left blank for this user
    def email_optional?
      false
    end

    # True if the password has been set and the password is not being
    # updated and we are not updating the password. Override to allow
    # other forms of authentication (username, facebook, etc).
    # @return [Boolean] true if the password field can be left blank for this user
    def password_optional?
      encrypted_password.present? && password.blank? && password_changing.blank?
    end

    def password_required?
      # warn "[DEPRECATION] password_required?: use !password_optional? instead"
      !password_optional?
    end

    def downcase_email
      self.email = email.to_s.downcase
    end
  end
end
