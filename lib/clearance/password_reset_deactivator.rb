module Clearance
  class PasswordResetDeactivator
    def initialize(user)
      @user = user
    end

    def run
      PasswordReset.active_for(user).deactivate_all
    end

    private

    attr_reader :user
  end
end
