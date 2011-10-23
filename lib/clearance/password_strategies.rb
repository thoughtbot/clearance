module Clearance
  module PasswordStrategies
    autoload :SHA1, 'clearance/password_strategies/sha1'
    autoload :Blowfish, 'clearance/password_strategies/blowfish'
    autoload :BCrypt, 'clearance/password_strategies/bcrypt'
    autoload :Fake, 'clearance/password_strategies/fake'
    autoload :BCryptMigrationFromSHA1, 'clearance/password_strategies/bcrypt_migration_from_sha1'
  end
end
