module Clearance
  class PasswordResetsDeactivator
    def initialize(user)
      @user = user
    end

    def run
      active_password_resets.each(&:deactivate!)
    end

    private

    attr_reader :user

    def active_password_resets
      PasswordReset.active_for(user)
    end
  end
end
