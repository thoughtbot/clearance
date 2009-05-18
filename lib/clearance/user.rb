require 'digest/sha1'

module Clearance
  module User

    def self.included(model)
      model.extend(ClassMethods)

      model.send(:include, InstanceMethods)
      model.send(:include, AttrAccessible)
      model.send(:include, AttrAccessor)
      model.send(:include, Validations)
      model.send(:include, Callbacks)
    end

    module AttrAccessible
      def self.included(model)
        model.class_eval do
          attr_accessible :email, :password, :password_confirmation
        end
      end
    end

    module AttrAccessor
      def self.included(model)
        model.class_eval do
          attr_accessor :password, :password_confirmation
        end
      end
    end

    module Validations
      def self.included(model)
        model.class_eval do
          validates_presence_of     :email
          validates_uniqueness_of   :email, :case_sensitive => false
          validates_format_of       :email, :with => %r{.+@.+\..+}

          validates_presence_of     :password, :if => :password_required?
          validates_confirmation_of :password, :if => :password_required?
        end
      end
    end

    module Callbacks
      def self.included(model)
        model.class_eval do
          before_save :initialize_salt, :encrypt_password, :initialize_token
        end
      end
    end

    module InstanceMethods
      def authenticated?(password)
        encrypted_password == encrypt(password)
      end

      def encrypt(string)
        generate_hash("--#{salt}--#{string}--")
      end

      def remember?
        token_expires_at && Time.now.utc < token_expires_at
      end

      def remember_me!
        remember_me_until! 2.weeks.from_now.utc
      end

      def forget_me!
        clear_token
        save(false)
      end

      def confirm_email!
        self.email_confirmed  = true
        self.token            = nil
        save(false)
      end

      def forgot_password!
        generate_token
        save(false)
      end

      def update_password(new_password, new_password_confirmation)
        self.password              = new_password
        self.password_confirmation = new_password_confirmation
        clear_token if valid?
        save
      end

      protected

      def generate_hash(string)
        Digest::SHA1.hexdigest(string)
      end

      def initialize_salt
        if new_record?
          self.salt = generate_hash("--#{Time.now.utc.to_s}--#{password}--")
        end
      end

      def encrypt_password
        return if password.blank?
        self.encrypted_password = encrypt(password)
      end

      def generate_token
        self.token = encrypt("--#{Time.now.utc.to_s}--#{password}--")
        self.token_expires_at = nil
      end

      def clear_token
        self.token            = nil
        self.token_expires_at = nil
      end

      def initialize_token
        generate_token if new_record?
      end

      def password_required?
        encrypted_password.blank? || !password.blank?
      end

      def remember_me_until!(time)
        self.token_expires_at = time
        self.token = encrypt("--#{token_expires_at}--#{password}--")
        save(false)
      end
    end

    module ClassMethods
      def authenticate(email, password)
        return nil  unless user = find_by_email(email)
        return user if     user.authenticated?(password)
      end
    end

  end
end
