require 'digest/sha1'

module Clearance
  module User
    extend ActiveSupport::Concern

    included do
      attr_accessor :password_changing
      attr_reader :password

      include Validations
      include Callbacks
      include (Clearance.configuration.password_strategy ||
        Clearance::PasswordStrategies::BCrypt)
    end

    module ClassMethods
      def authenticate(email, password)
        if user = find_by_email(email.to_s.downcase)
          if user.authenticated? password
            return user
          end
        end
      end
    end

    module Validations
      extend ActiveSupport::Concern

      included do
        validates_presence_of :email, :unless => :email_optional?
        validates_uniqueness_of :email, :allow_blank => true
        validates_format_of :email, :with => %r{^[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$}i, :allow_blank => true

        validates_presence_of :password, :unless => :password_optional?
      end
    end

    module Callbacks
      extend ActiveSupport::Concern

      included do
        before_validation :downcase_email
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

    def downcase_email
      self.email = email.to_s.downcase
    end

    def email_optional?
      false
    end

    def generate_confirmation_token
      self.confirmation_token = SecureRandom.hex(20).encode('UTF-8')
    end

    def generate_remember_token
      self.remember_token = SecureRandom.hex(20).encode('UTF-8')
    end

    def password_optional?
      encrypted_password.present? && password.blank? && password_changing.blank?
    end
  end
end
