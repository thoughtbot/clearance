module Clearance
    module PasswordStrategies
      # Uses Argon2 to authenticate users and store encrypted passwords.

      module Argon2
        require 'argon2'
  
        def authenticated?(password)
          if encrypted_password.present?
            Argon2::Password.verify_password(password, encrypted_password)
          end
        end
  
        def password=(new_password)
          @password = new_password
  
          if new_password.present?
            hasher = Argon2::Password.new(t_cost: 2, m_cost: 16)
  
            self.encrypted_password = hasher.create("password")
          end
        end
      end
    end
  end
  