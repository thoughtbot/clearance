module Clearance
  class Config
    attr_accessor :url_after_sign_up

    def initialize
      @url_after_sign_up = "/"
    end
  end
end
