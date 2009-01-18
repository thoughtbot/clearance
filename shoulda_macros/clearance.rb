module Clearance 
  module Shoulda

    # STATE OF AUTHENTICATION

    def should_be_logged_in_and_confirmed_as(user)
      should "be logged in" do
        assert_equal user.id,   session[:user_id]
        assert_equal user.salt, session[:salt]
      end
      
      should "be a confirmed user" do
        assert_not_nil user
        assert_equal user, assigns(:user)
        assert assigns(:user).confirmed?
      end
    end

    def should_deny_access_on(command, opts = {})
      context "on #{command}" do
        setup { eval command }
        should_deny_access(opts)
      end
    end

    def should_deny_access(opts = {})
      if opts[:flash]
        should_set_the_flash_to opts[:flash]
      else
        should_not_set_the_flash
      end
      
      should "respond with 401 Unauthorized and render login template" do
        assert_response :unauthorized, 
          "access was expected to be denied (401 unauthorized)"
        assert_template "sessions/new",
          "template was expected to be login (sessions/new)"
      end
    end
    
    # CONTEXTS

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
    
    # RENDERING
    
    def should_render_nothing
      should "render nothing" do
        assert @response.body.blank?
      end
    end
    
  end
end

Test::Unit::TestCase.extend(Clearance::Shoulda)
