module Clearance
  # Control how users are authenticated and how passwords are stored.
  #
  # The default password strategy is {Clearance::PasswordStrategies::BCrypt},
  # but this can be overridden in {Clearance::Configuration}.
  #
  # You can supply your own password strategy by implementing a module that
  # responds to the proper interface methods. Once this module is configured as
  # your password strategy, Clearance will mix it into your Clearance User
  # class. Thus, your module can access any methods or attributes on User.
  #
  # Password strategies need to respond to `authenticated?(password)` and
  # `password=(new_password)`. For an example of how to implement these methods,
  # see {Clearance::PasswordStrategies::BCrypt}.
  module PasswordStrategies
    autoload :BCrypt, "clearance/password_strategies/bcrypt"
    autoload :Argon2, "clearance/password_strategies/argon2"
  end
end
