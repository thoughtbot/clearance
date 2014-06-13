module Clearance
  class Configuration < SimpleDelegator
    attr_accessor :url_after_sign_in, :url_after_sign_out, :url_after_sign_up
    attr_accessor :user_class, :password_reset_class
    attr_accessor :password_reset_mailer, :password_reset_delivery
    attr_accessor :mailer_sender

    def initialize
      super Monban.config
      @url_after_sign_in = "/"
      @url_after_sign_up = "/"
      @url_after_sign_out = "/"
      @mailer_sender = "reply@example.com"
      @user_class = Monban.user_class
      @password_reset_class = Clearance::PasswordReset
      @password_reset_mailer = ClearanceMailer
      @password_reset_delivery = default_password_reset_delivery
    end

    private

    def default_password_reset_delivery
      ->(password_reset) do
        password_reset_mailer.change_password(password_reset).deliver
      end
    end
  end
end
