module Clearance 
  module Test
    module TestHelper
    
      def self.included(test_helper)
        test_helper.class_eval do
          
          def login_as(user = nil)
            unless user
              user = Factory(:clearance_user)
              user.confirm!
            end
            @request.session[:user_id] = user.id
            @request.session[:salt]    = user.salt
            return user
          end

          def logout 
            @request.session[:user_id] = nil
            @request.session[:salt]    = nil
          end
          
        end
      end
 
    end 
  end
end
