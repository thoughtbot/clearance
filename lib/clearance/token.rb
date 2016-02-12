module Clearance
  # Random token used for password reset and remember tokens.
  # Clearance tokens are also public API and are inteded to be used anywhere you
  # need a random token to correspond to a given user (e.g. you added an email
  # confirmation token).
  class Token
    # Generate a new random, 20 byte hex token.
    #
    # @return [String]
    def self.new
      SecureRandom.hex(20).encode('UTF-8')
    end
  end
end
