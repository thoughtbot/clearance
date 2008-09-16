module Clearance
  module SessionsControllerTest
    
    def self.included(base)
      base.class_eval do
        context "Given a user" do
          setup do
            @user = Factory(:user)
          end

          should_filter :password

          context "on GET to /sessions/new" do
            setup { get :new }
          
            should_respond_with :success
            should_render_template :new
            should_not_set_the_flash
            should "have login form" do
              assert_select "form[action$=/session]" do
                assert_select "input[type=text][name=?]",     "session[email]"
                assert_select "input[type=password][name=?]", "session[password]"
                assert_select "input[type=checkbox][name=?]", "session[remember_me]"
              end
            end
          end

          context "a POST to #create with good credentials" do
            setup do
              post :create, :session => { :email => @user.email, :password => @user.password }
            end

            should_set_the_flash_to /success/i
            should_redirect_to 'root_url'
            # should set session
          end

          context "a POST to #create with bad credentials" do
            setup do
              post :create, :session => { :email => @user.email, :password => "bad value" }
            end

            should_set_the_flash_to /bad/i
            should_render_template :new
            # should not set session
          end
          
          # two tests for remember me - success and failure
        end

        context "While logged out" do
          setup { logout }

          context "logging out again" do
            setup { delete :destroy }
            should_redirect_to "login_url"
          end
        end

        logged_in_user_context do
          context "a DELETE to #destroy without a cookie" do
            setup { delete :destroy }

            should_set_the_flash_to(/logged out/i)
            should_redirect_to "login_url"
          end

          context 'a DELETE to #destroy with a cookie' do
            setup do
              cookies['auth_token'] = CGI::Cookie.new 'token', 'value'
              delete :destroy
            end

            should 'delete the cookie' do
              assert cookies['auth_token'].empty?
            end

            should 'delete the remember me token in users table' do
              assert_nil @user.reload.remember_token
              assert_nil @user.reload.remember_token_expires_at
            end
          end
        end
      end
    end
  end
end
