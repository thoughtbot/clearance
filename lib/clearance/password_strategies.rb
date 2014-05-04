module Clearance
  module PasswordStrategies
    autoload :BCrypt, 'clearance/password_strategies/bcrypt'
    autoload :BCryptMigrationFromSHA1,
      'clearance/password_strategies/bcrypt_migration_from_sha1'
    autoload :Blowfish, 'clearance/password_strategies/blowfish'
    autoload :SHA1, 'clearance/password_strategies/sha1'
  end
end
