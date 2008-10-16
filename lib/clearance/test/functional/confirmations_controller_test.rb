module Clearance
  module Test
    module Functional
      module ConfirmationsControllerTest

        def self.included(base)
          base.class_eval do

            context 'A GET to #new' do
              context "with the User with the given id's salt" do
                setup do
                  @user = Factory :user
                  get :new, :user_id => @user.to_param, :salt => @user.salt
                end

                should 'find the User record with the given id and salt' do
                  assert_equal @user, assigns(:user)
                end

                should_respond_with :success
                should_render_template :new
              end

              context "without the User with the given id's salt" do
                setup do
                  user = Factory :user
                  salt = ''
                  assert_not_equal salt, user.salt

                  get :new, :user_id => user.to_param, :salt => ''
                end

                should_respond_with :not_found

                should 'render nothing' do
                  assert @response.body.blank?
                end
              end
            end

            context 'A POST to #create' do
              context "with the User with the given id's salt" do
                setup do
                  @user = Factory :user
                  assert ! @user.confirmed?

                  post :create, :user_id => @user, :salt => @user.salt
                  @user.reload
                end

                should 'confirm the User record with the given id' do
                  assert @user.confirmed?
                end

                should 'log the User in' do
                  assert_equal @user.id, session[:user_id]
                end

                should_redirect_to "@controller.send(:url_after_create)"
              end

              context "without the User with the given id's salt" do
                setup do
                  user = Factory :user
                  salt = ''
                  assert_not_equal salt, user.salt

                  post :create, :user_id => user.id, :salt => salt
                end

                should_respond_with :not_found

                should 'render nothing' do
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
