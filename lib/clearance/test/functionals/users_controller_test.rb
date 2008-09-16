module Clearance
  module UsersControllerTest
  
    def self.included(base)
      base.class_eval do
        public_context do
          
          should_deny_access_on "get :new"
          should_deny_access_on "post :create, :user => {}"
          should_deny_access_on "get :edit, :id => 1"
          should_deny_access_on "put :update, :id => 1"
          should_deny_access_on "get :show, :id => 1"
          should_deny_access_on "delete :destroy, :id => 1"
          
        end
        
        logged_in_user_context do

          should_deny_access_on "get :new"
          should_deny_access_on "post :create, :user => {}" 
          should_filter :password

          context "viewing their account" do
            context "on GET to /users/:id/show" do
              setup { get :show, :id => @user.to_param }
              should_respond_with :success
              should_render_template :show
              should_not_set_the_flash
              
              should 'assign to @user' do
                assert_equal @user, assigns(:user)
              end
            end

            should_deny_access_on "delete :destroy, :id => @user.to_param"

            context "on GET to /users/:id/edit" do
              setup { get :edit, :id => @user.to_param }

              should_respond_with :success
              should_render_template :edit
              should_not_set_the_flash
              should_assign_to :user
              should_have_user_form
            end

            context "on PUT to /users/:id" do
              setup do
                put :update, 
                  :id => @user.to_param, 
                  :user => { :email => "none@example.com" }
              end
              should_set_the_flash_to /updated/i
              should_redirect_to "root_url"
              should_assign_to :user
              should "update the user's attributes" do
                assert_equal "none@example.com", assigns(:user).email
              end
            end

            context "on PUT to /users/:id with invalid attributes" do
              setup { put :update, :id => @user.to_param, :user => {:email => ''} }
              should_not_set_the_flash
              should_assign_to :user
              should_render_template 'edit'
              should "display errors" do
                assert_select '#errorExplanation'
              end
            end
          end

          context "dealing with another user's account" do
            setup do
              @user = Factory :user
            end

            should_deny_access_on "get :show, :id => @user.to_param",                :flash => /cannot edit/i
            should_deny_access_on "get :edit, :id => @user.to_param",                :flash => /cannot edit/i
            should_deny_access_on "put :update, :id => @user.to_param, :user => {}", :flash => /cannot edit/i
          end
        end
      end
    end

  end
end
