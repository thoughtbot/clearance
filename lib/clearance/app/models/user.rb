require 'digest/sha2'

module Clearance
  module App
    module Models
      module User
    
        def self.included(model)
          model.class_eval do
        
            attr_accessible :email, :password, :password_confirmation
            attr_accessor :password, :password_confirmation

            validates_presence_of     :email
            validates_presence_of     :password, :if => :password_required?
            validates_confirmation_of :password, :if => :password_required?
            validates_uniqueness_of   :email, :case_sensitive => false
            validates_format_of       :email, :with => %r{.+@.+\..+}

            before_save :initialize_salt, :encrypt_password, :downcase_email
        
            def self.authenticate(email, password)
              user = find(:first, :conditions => ['LOWER(email) = ?', email.to_s.downcase])
              user && user.authenticated?(password) ? user : nil
            end

            def authenticated?(password)
              crypted_password == encrypt(password)
            end

            def encrypt(password)
              Digest::SHA512.hexdigest("--#{salt}--#{password}--")
            end

            def unexpired_remember_token?
              remember_token_expires_at && Time.now.utc < remember_token_expires_at
            end

            def remember_me!
              remember_me_until 2.weeks.from_now.utc
            end

            def remember_me_until(time)
              self.update_attribute :remember_token_expires_at, time
              self.update_attribute :remember_token, 
                encrypt("--#{email}--#{remember_token_expires_at}--")
            end

            def forget_me!
              self.update_attribute :remember_token_expires_at, nil
              self.update_attribute :remember_token, nil
            end

            def confirm!
              self.update_attribute :confirmed, true
            end
        
            protected

            def initialize_salt
              if new_record?
                self.salt = Digest::SHA512.hexdigest("--#{Time.now.utc.to_s}--#{email}--")
              end
            end

            def encrypt_password
              return if password.blank?
              self.crypted_password = encrypt(password)
            end

            def password_required?
              crypted_password.blank? || !password.blank?
            end
            
            def downcase_email
              self.email = email.to_s.downcase
            end
        
          end
        end
  
      end
    end
  end
end
