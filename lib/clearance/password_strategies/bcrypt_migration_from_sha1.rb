module Clearance
  module PasswordStrategies
    module BCryptMigrationFromSHA1
      class BCryptUser
        include Clearance::PasswordStrategies::BCrypt

        def initialize(user)
          @user = user
        end

        delegate :encrypted_password, :encrypted_password=, to: :@user
      end

      class SHA1User
        include Clearance::PasswordStrategies::SHA1

        def initialize(user)
          @user = user
        end

        delegate :salt, :salt=, :encrypted_password, :encrypted_password=, to: :@user
      end

      def authenticated?(password)
        authenticated_with_sha1?(password) || authenticated_with_bcrypt?(password)
      end

      def password=(new_password)
        @password = new_password
        BCryptUser.new(self).password = new_password
      end

      private

      def authenticated_with_bcrypt?(password)
        begin
          BCryptUser.new(self).authenticated? password
        rescue ::BCrypt::Errors::InvalidHash
          false
        end
      end

      def authenticated_with_sha1?(password)
        if sha1_password?
          if SHA1User.new(self).authenticated? password
            self.password = password
            true
          end
        end
      end

      def sha1_password?
        self.encrypted_password =~ /^[a-f0-9]{40}$/
      end
    end
  end
end
