module Clearance 
  module Test
    module TestHelper
    
      def self.included(base)
        base.class_eval do
          include InstanceMethods
          extend ClassMethods
        end
      end

      module InstanceMethods
        def login_as(user = nil)
          user ||= Factory(:clearance_user)
          @request.session[:user_id] = user.id
          return user
        end

        def logout 
          @request.session[:user_id] = nil
        end
      end
    
      module ClassMethods
      end
 
    end 
  end
end
