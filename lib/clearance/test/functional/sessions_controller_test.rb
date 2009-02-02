module Clearance
  module Test
    module Functional
      module SessionsControllerTest
    
        def self.included(controller_test)
          controller_test.class_eval do
            
            should_filter_params :password

            context "on GET to /sessions/new" do
              setup { get :new }
        
              should_respond_with :success
              should_render_template :new
              should_not_set_the_flash
              
              should_display_a_sign_in_form
            end

            context "Given a user" do
              setup { @user = Factory(:user) }

              context "a POST to #create with good credentials" do
                setup do
                  ActionMailer::Base.deliveries.clear
                  post :create, :session => {
                                  :email    => @user.email,
                                  :password => @user.password }
                end

                should_deny_access(:flash => /User has not confirmed email.  Confirmation email will be resent./i)

                should "send the confirmation email" do
                  assert_not_nil email = ActionMailer::Base.deliveries[0]
                  assert_match /account confirmation/i, email.subject
                end

              end
            end

            context "Given an email confirmed user" do
              setup do
                @user = Factory(:user)
                @user.confirm_email!              
              end 

              context "a POST to #create with good credentials" do
                setup do
                  post :create, :session => { 
                                  :email    => @user.email, 
                                  :password => @user.password }
                end

                should_set_the_flash_to /success/i
                should_redirect_to_url_after_create
                should_be_signed_in_as { @user }
              end

              context "a POST to #create with bad credentials" do
                setup do
                  post :create, :session => { 
                                  :email    => @user.email, 
                                  :password => "bad value" }
                end

                should_set_the_flash_to /bad/i
                should_render_template :new
                should_not_be_signed_in
              end
          
              context "a POST to #create with good credentials and remember me" do
                setup do
                  post :create, :session => { 
                                  :email       => @user.email, 
                                  :password    => @user.password, 
                                  :remember_me => '1' }
                end

                should_set_the_flash_to /success/i
                should_redirect_to_url_after_create
                should_be_signed_in_as { @user }
                
                should 'set the cookie' do
                  assert ! cookies['remember_token'].empty?
                end

                should 'set the token in users table' do
                  assert_not_nil @user.reload.token
                  assert_not_nil @user.reload.token_expires_at
                end
              end
              
              context "a POST to #create with bad credentials and remember me" do
                setup do
                  post :create, :session => { 
                                  :email       => @user.email, 
                                  :password    => "bad value", 
                                  :remember_me => '1' }
                end

                should_set_the_flash_to /bad/i
                should_render_template :new
                should_return_from_session :user_id, "nil"
                
                should 'not create the cookie' do
                  assert_nil cookies['remember_token']
                end

                should 'not set the remember me token in users table' do
                  assert_nil @user.reload.token
                  assert_nil @user.reload.token_expires_at
                end
              end
              
              context "a POST to #create with good credentials and A URL to return back" do
                context "in the session" do
                  setup do
                    @request.session[:return_to] = '/url_in_the_session'
                    post :create, :session => { 
                                    :email    => @user.email, 
                                    :password => @user.password }                    
                  end
                  
                  should_redirect_to "'/url_in_the_session'"
                end
                
                context "in the request" do
                  setup do
                    post :create, :session => { 
                                    :email => @user.email, 
                                    :password => @user.password },
                                    :return_to => '/url_in_the_request'                    
                  end
                  
                  should_redirect_to "'/url_in_the_request'"
                end   
                             
                context "in the request and in the session" do
                  setup do
                    @request.session[:return_to] = '/url_in_the_session'
                    post :create, :session => { 
                                    :email    => @user.email, 
                                    :password => @user.password },
                                    :return_to => '/url_in_the_request'                    
                  end
                  
                  should_redirect_to "'/url_in_the_session'"
                end
              end              
            end

            public_context do
              context "logging out again" do
                setup { delete :destroy }
                should_redirect_to_url_after_destroy
              end
            end

            signed_in_user_context do
              context "a DELETE to #destroy without a cookie" do
                setup { delete :destroy }

                should_set_the_flash_to(/signed out/i)
                should_redirect_to_url_after_destroy
              end

              context 'a DELETE to #destroy with a cookie' do
                setup do
                  cookies['remember_token'] = CGI::Cookie.new('token', 'value')
                  delete :destroy
                end

                should 'delete the cookie' do
                  assert cookies['remember_token'].empty?
                end

                should 'delete the remember me token in users table' do
                  assert_nil @user.reload.token
                  assert_nil @user.reload.token_expires_at
                end
              end
            end
          
          end
        end

      end
    end
  end
end
