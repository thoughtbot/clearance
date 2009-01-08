require 'digest/sha1'

module Clearance
  module App
    module Models
      module User
    
        def self.included(base)
          base.class_eval do
        
            attr_accessible :email, :password, :password_confirmation
            attr_accessor :password, :password_confirmation

            validates_presence_of     :email
            validates_presence_of     :password, :if => :password_required?
            validates_confirmation_of :password, :if => :password_required?
            validates_uniqueness_of   :email, :case_sensitive => false
            validates_format_of       :email, :with => %r{.+@.+\..+}

            before_save :initialize_salt, :encrypt_password
        
            extend ClassMethods
            include InstanceMethods
        
          protected

            include ProtectedInstanceMethods
        
          end
        end
    
        module ClassMethods
          def authenticate(email, password)
            user = find(:first, :conditions => ['LOWER(email) = ?', email.to_s.downcase])
            user && user.authenticated?(password) ? user : nil
          end
        end
    
        module InstanceMethods
          def email=(value)
            value = value.to_s.downcase if value
            write_attribute(:email, value.to_s)
          end
        
          def authenticated?(password)
            crypted_password == encrypt(password)
          end

          def encrypt(password)
            Digest::SHA1.hexdigest "--#{salt}--#{password}--"
          end

          def remember_token?
            remember_token_expires_at && Time.now.utc < remember_token_expires_at
          end

          def remember_me!
            remember_me_until 2.weeks.from_now.utc
          end

          def remember_me_until(time)
            self.update_attribute :remember_token_expires_at, time
            self.update_attribute :remember_token, encrypt("#{email}--#{remember_token_expires_at}")
          end

          def forget_me!
            self.update_attribute :remember_token_expires_at, nil
            self.update_attribute :remember_token, nil
          end
        
          def confirm!
            self.update_attribute :confirmed, true
          end
        end
    
        module ProtectedInstanceMethods
          def initialize_salt
            self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
          end

          def encrypt_password
            return if password.blank?
            self.crypted_password = encrypt(password)
          end

          def password_required?
            crypted_password.blank? || !password.blank?
          end
        end
  
      end
    end
  end
end
