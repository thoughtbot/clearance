module Clearance
  module Test
    module Functional
      module PasswordsControllerTest

        def self.included(base)
          base.class_eval do

            should_route :get, '/users/1/password/edit', :action => 'edit', :user_id => '1'

            context 'with a user' do
              setup { @user = Factory :user }

              context 'A GET to #new' do
                setup { get :new, :user_id => @user.to_param }

                should_respond_with :success
                should_render_template 'new'
              end

              context 'A POST to #create' do
                context "with an existing user's email address" do
                  setup do
                    ActionMailer::Base.deliveries.clear

                    post :create, :password => { :email => @user.email }
                    @email = ActionMailer::Base.deliveries[0]
                  end

                  should 'send an email to the user to edit their password' do
                    assert @email.subject =~ /change your password/i
                  end
                  
                  should 'set a :notice flash with the user email address' do
                    assert_match /#{@user.email}/, flash[:notice]
                  end

                  should_redirect_to "@controller.send(:url_after_create)"
                end

                context 'with a non-existing email address' do
                  setup do
                    email = 'user1@example.com'
                    assert ! User.exists?(['email = ?', email])
                    ActionMailer::Base.deliveries.clear

                    post :create, :password => { :email => email }
                  end

                  should 'not send a password reminder email' do
                    assert ActionMailer::Base.deliveries.empty?
                  end

                  should 'set a :warning flash' do
                    assert_not_nil flash.now[:warning]
                  end

                  should_render_template "new"
                end
              end

              context 'A GET to #edit' do
                context "with an existing user's id and password" do
                  setup do
                    get :edit, 
                      :user_id => @user.to_param, 
                      :password => @user.crypted_password, 
                      :email => @user.email
                  end

                  should 'find the user with the given id and password' do
                    assert_equal @user, assigns(:user)
                  end

                  should_respond_with :success
                  should_render_template "edit"

                  should "have a form for the user's email, password, and password confirm" do
                    update_path = ERB::Util.h(user_password_path(@user,
                          :password => @user.crypted_password,
                          :email    => @user.email))

                    assert_select 'form[action=?]', update_path do
                      assert_select 'input[name=_method][value=?]', 'put'
                      assert_select 'input[name=?]', 'user[password]'
                      assert_select 'input[name=?]', 'user[password_confirmation]'
                    end
                  end
                end

                context "with an existing user's id but not password" do
                  setup do
                    get :edit, :user_id => @user.to_param, :password => ''
                  end

                  should_respond_with :not_found

                  should 'render an empty response' do
                    assert @response.body.blank?
                  end
                end
              end

              context 'A PUT to #update' do
                context "with an existing user's id but not password" do
                  setup do
                    put :update, :user_id => @user.to_param, :password => ''
                  end

                  should "not update the user's password" do
                    assert_not_equal @encrypted_new_password, @user.crypted_password
                  end

                  should 'not log the user in' do
                    assert_nil session[:user_id]
                  end

                  should_respond_with :not_found

                  should 'render an empty response' do
                    assert @response.body.blank?
                  end
                end

                context 'with a matching password and password confirmation' do
                  setup do
                    new_password = 'new_password'
                    encryption_format = "--#{@user.salt}--#{new_password}--"
                    @encrypted_new_password = Digest::SHA1.hexdigest encryption_format
                    assert_not_equal @encrypted_new_password, @user.crypted_password

                    put(:update,
                        :user_id  => @user,
                        :email    => @user.email,
                        :password => @user.crypted_password,
                        :user => {
                          :password              => new_password,
                          :password_confirmation => new_password
                        })
                    @user.reload
                  end

                  should "update the user's password" do
                    assert_equal @encrypted_new_password, @user.crypted_password
                  end

                  should 'log the user in' do
                    assert_equal session[:user_id], @user.id
                  end

                  should_redirect_to "user_path(@user)"
                end

                context 'with password but blank password confirmation' do
                  setup do
                    new_password = 'new_password'
                    encryption_format = "--#{@user.salt}--#{new_password}--"
                    @encrypted_new_password = Digest::SHA1.hexdigest encryption_format

                    put(:update,
                        :user_id => @user.to_param,
                        :password => @user.crypted_password,
                        :user => {
                          :password => new_password,
                          :password_confirmation => ''
                        })
                    @user.reload
                  end

                  should "not update the user's password" do
                    assert_not_equal @encrypted_new_password, @user.crypted_password
                  end

                  should 'not log the user in' do
                    assert_nil session[:user_id]
                  end

                  should_respond_with :not_found

                  should 'render an empty response' do
                    assert @response.body.blank?
                  end
                end
              end
            end
          end
        end

      end
    end
  end
end
