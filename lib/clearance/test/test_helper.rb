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
        def should_deny_access_on(command, opts = {})

          context "on #{command}" do
            setup { eval command }
            should_deny_access(opts)
          end
        end

        def should_deny_access(opts = {})
          opts[:redirect] ||= "new_session_path"
          should_redirect_to opts[:redirect]
          if opts[:flash]
            should_set_the_flash_to opts[:flash]
          else
            should_not_set_the_flash
          end
        end
   
        def logged_in_user_context(&blk)
          context "A logged in user" do
            setup do
              @user = Factory :clearance_user
              login_as @user
            end
            merge_block(&blk)
          end
        end
      
        def public_context(&blk)
          context "The public" do
            setup { logout }
            merge_block(&blk)
          end
        end
      end
 
    end 
  end
end
