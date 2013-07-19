require 'digest/sha1'
require 'email_validator'

module Clearance
  module User
    extend ActiveSupport::Concern

    included do
      attr_accessor :password_changing
      attr_reader :password

      include Validations
      include Callbacks
      include password_strategy
    end

    module ClassMethods
      def authenticate(email, password)
        if user = find_by_normalized_email(email)
          if password.present? && user.authenticated?(password)
            return user
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

    module Validations
      extend ActiveSupport::Concern

      included do
        validates :email,
          email: true,
          presence: true,
          uniqueness: { allow_blank: true },
          unless: :email_optional?

        validates :password, presence: true, unless: :skip_password_validation?
      end
    end

    module Callbacks
      extend ActiveSupport::Concern

      included do
        before_validation :normalize_email
        before_create :generate_remember_token
      end
    end

    def forgot_password!
      generate_confirmation_token
      save :validate => false
    end

    def reset_remember_token!
      generate_remember_token
      save :validate => false
    end

    def update_password(new_password)
      self.password_changing = true
      self.password = new_password

      if valid?
        self.confirmation_token = nil
        generate_remember_token
      end

      save
    end

    private

    def normalize_email
      self.email = self.class.normalize_email(email)
    end

    def email_optional?
      false
    end

    def password_optional?
      false
    end

    def skip_password_validation?
      password_optional? || (encrypted_password.present? && !password_changing)
    end

    def generate_confirmation_token
      self.confirmation_token = SecureRandom.hex(20).encode('UTF-8')
    end

    def generate_remember_token
      self.remember_token = SecureRandom.hex(20).encode('UTF-8')
    end
  end
end
