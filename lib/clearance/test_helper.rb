module Clearance 
  module TestHelper

    def login_as(user = nil)
      user ||= Factory(:user)
      @request.session[:user_id] = user.id
      return user
    end
  
    def logout 
      @request.session[:user_id] = nil
    end
    
    def included(base)
      base.class_eval do
        extend ClassMethods
      end
    end
    
    module ClassMethods
      def should_deny_access_on(command, opts = {})
        opts[:redirect] ||= "login_url"

        context "on #{command}" do
          setup { eval command }
          should_redirect_to opts[:redirect]
          if opts[:flash]
            should_set_the_flash_to opts[:flash]
          else
            should_not_set_the_flash
          end
        end
      end
      
      def should_filter(*keys)
        keys.each do |key|
          should "filter #{key}" do
            assert @controller.respond_to?(:filter_parameters),
              "The key #{key} is not filtered"
            filtered = @controller.send(:filter_parameters, {key.to_s => key.to_s})
            assert_equal '[FILTERED]', filtered[key.to_s],
              "The key #{key} is not filtered"
          end
        end
      end

      def logged_in_user_context(user_name = nil, &blk)
        context "When logged in as a user" do
          setup do
            user = user_name ? instance_variable_get("@#{user_name}") : Factory(:user)
            assert @current_user    = login_as(user)
          end
          merge_block(&blk)
        end
      end
    end
  
  end
end
