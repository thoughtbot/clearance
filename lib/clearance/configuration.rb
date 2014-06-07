module Clearance
  class Configuration < SimpleDelegator
    attr_accessor :url_after_sign_in, :url_after_sign_out, :url_after_sign_up
    attr_accessor :user_class

    def initialize
      super Monban.config
      @url_after_sign_in = "/"
      @url_after_sign_up = "/"
      @url_after_sign_out = "/"
      @user_class = Monban.user_class
    end
  end
end
