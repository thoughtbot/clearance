module Clearance
  module UsersController

    def self.included(base)
      base.class_eval do
        before_filter :authenticate
        before_filter :ensure_user_is_accessing_self, :only => [:edit, :update, :show]

        filter_parameter_logging :password
      private
        include PrivateInstanceMethods
      end
    end

    module PrivateInstanceMethods
      def ensure_user_is_accessing_self
        deny_access 'You cannot edit that user.' unless current_user.id.to_i == params[:id].to_i
      end
    end

  end
end
