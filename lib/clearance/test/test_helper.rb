module Clearance 
  module Test
    module TestHelper
    
      def self.included(test_helper)
        test_helper.class_eval do
          
          def sign_in_as(user = nil)
            unless user
              user = Factory(:user)
              user.confirm_email!
            end
            @request.session[:user_id] = user.id
            return user
          end

          def sign_out 
            @request.session[:user_id] = nil
          end
          
        end
      end
 
    end 
  end
end
