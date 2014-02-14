module Clearance
  class Token
    def self.new
      SecureRandom.hex(20).encode('UTF-8')
    end
  end
end
