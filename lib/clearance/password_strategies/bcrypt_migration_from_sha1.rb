module Clearance
  module PasswordStrategies
    # @deprecated Use {BCrypt} or `clearance-deprecated_password_strategies` gem
    module BCryptMigrationFromSHA1
      DEPRECATION_MESSAGE = "[DEPRECATION] The BCryptMigrationFromSha1 " \
        "password strategy has been deprecated and will be removed from " \
        "Clearance 2.0. BCrypt is the only officially supported strategy, " \
        "though you are free to provide your own. To continue using this " \
        "strategy, add clearance-deprecated_password_strategies to your " \
        "Gemfile."

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
        warn "#{Kernel.caller.first}: #{DEPRECATION_MESSAGE}"
        authenticated_with_sha1?(password) || authenticated_with_bcrypt?(password)
      end

      def password=(new_password)
        warn "#{Kernel.caller.first}: #{DEPRECATION_MESSAGE}"
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
            self.save
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
