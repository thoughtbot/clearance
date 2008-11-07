module Clearance
  module Test
    module Functional
      module SessionsControllerTest
    
        def self.included(base)
          base.class_eval do
            should_filter_params :password

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

            context "Given an unconfirmed user" do
              setup do
                @user = Factory(:user, :confirmed => false)
              end

              context "a POST to #create with good credentials" do
                setup do
                  ActionMailer::Base.deliveries.clear
                  post :create, :session => {
                                  :email => @user.email,
                                  :password => @user.password
                  }
                end

                should_deny_access(:flash => /confirm/i)

                should "send the confirmation email" do
                  assert_not_nil email = ActionMailer::Base.deliveries[0]
                  assert_match /account confirmation/i, email.subject
                end
              end
            end

            context "Given a confirmed user" do
              setup { @user = Factory(:user, :confirmed => true) }

              context "a POST to #create with good credentials" do
                setup do
                  post :create, :session => { :email => @user.email, 
                    :password => @user.password }
                end

                should_set_the_flash_to /success/i
                should_redirect_to '@controller.send(:url_after_create)'
                should_return_from_session :user_id, "@user.id"
              end

              context "a POST to #create with bad credentials" do
                setup do
                  post :create, :session => { :email => @user.email, 
                    :password => "bad value" }
                end

                should_set_the_flash_to /bad/i
                should_render_template :new
                should_return_from_session :user_id, "nil"
              end
          
              context "a POST to #create with good credentials and remember me" do
                setup do
                  post :create, :session => { :email => @user.email, 
                    :password => @user.password, :remember_me => '1' }
                end

                should_set_the_flash_to /success/i
                should_redirect_to "@controller.send(:url_after_create)"
                should_return_from_session :user_id, "@user.id"
                
                should 'set the cookie' do
                  assert ! cookies['auth_token'].empty?
                end

                should 'set the remember me token in users table' do
                  assert_not_nil @user.reload.remember_token
                  assert_not_nil @user.reload.remember_token_expires_at
                end
              end
              
              context "a POST to #create with bad credentials and remember me" do
                setup do
                  post :create, :session => { :email => @user.email, 
                    :password => "bad value", :remember_me => '1' }
                end

                should_set_the_flash_to /bad/i
                should_render_template :new
                should_return_from_session :user_id, "nil"
                
                should 'not create the cookie' do
                  assert_nil cookies['auth_token']
                end

                should 'not set the remember me token in users table' do
                  assert_nil @user.reload.remember_token
                  assert_nil @user.reload.remember_token_expires_at
                end
              end
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
  end
end
