module Clearance
  module SessionsControllerTest
    
    def self.included(base)
      base.class_eval do
        context "Given a user" do
          setup { @user = Factory :user }

          should_filter :password

          context "on GET to /sessions/new" do
            setup { get :new }
          
            should_respond_with :success
            should_render_template :new
            should_not_set_the_flash
            should_have_form :action => "session_path",
              :fields => { "session[email]" => :text,
                "session[password]" => :password,
                "session[remember_me]" => :checkbox }
          end

          context "a POST to #create with good credentials" do
            setup do
              post :create, :session => { :email => @user.email, :password => @user.password }
            end

            should_set_the_flash_to /success/i
            should_redirect_to '@controller.send(:url_after_create)'
            #should_return_from_session(:user_id, '@user.id')
            should "return the correct value from the session for key :user_id" do
              instantiate_variables_from_assigns do
                expected_value = @user.id
                assert_equal expected_value, session[:user_id], "Expected #{expected_value.inspect} but was #{session[:user_id]}"
              end
            end
          end

          context "a POST to #create with bad credentials" do
            setup do
              post :create, :session => { :email => @user.email, :password => "bad value" }
            end

            should_set_the_flash_to /bad/i
            should_render_template :new
            #should_return_from_session(:user_id, 'nil')
            should "return nil from the session for key :user_id" do
              instantiate_variables_from_assigns do
                assert_nil session[:user_id], "Expected nil but was #{session[:user_id]}"
              end
            end
          end
          
          # TODO: two tests for remember me - success and failure
        end

        public_context do
          context "logging out again" do
            setup { delete :destroy }
            should_redirect_to '@controller.send(:url_after_destroy)'
          end
        end

        logged_in_user_context do
          context "a DELETE to #destroy without a cookie" do
            setup { delete :destroy }

            should_set_the_flash_to(/logged out/i)
            should_redirect_to '@controller.send(:url_after_destroy)'
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
