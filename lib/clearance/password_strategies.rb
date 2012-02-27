module Clearance
  module PasswordStrategies
    autoload :SHA1, 'clearance/password_strategies/sha1'
    autoload :Blowfish, 'clearance/password_strategies/blowfish'
  end
end
