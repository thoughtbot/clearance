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
      
    def self.should_deny_access_on(command, opts = {})
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
  
    def self.logged_in_user_context(user_name = nil, &blk)
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
