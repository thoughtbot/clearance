module Clearance
  module UsersControllerTest

    def self.included(base)
      base.class_eval do
        public_context do

          context "on GET to /users/new" do
            setup { get :new }
            should_respond_with :success
            should_render_template :new
            should_not_set_the_flash
            should_have_form :action => "users_path",
              :method => :post,
              :fields => { :email => :text,
                :password => :password,
                :password_confirmation => :password }

            context "with params" do
              setup do
                @email = 'a@example.com'
                get :new, :user => {:email => @email}
              end

              should_assign_to :user
              should "set the @user's params" do
                assert_equal @email, assigns(:user).email
              end
            end
          end

          context "on POST to /users" do
            setup do
              post :create, :user => {
                :email => Factory.next(:email),
                :password => 'skerit',
                :password_confirmation => 'skerit'
              }
            end
            
            should_set_the_flash_to /confirm/i
            should_redirect_to "@controller.send(:url_after_create)"
            should_assign_to :user
            should_change 'User.count', :by => 1
          end

        end

        logged_in_user_context do

          should_deny_access_on "get :new"
          should_deny_access_on "post :create, :user => {}" 
          should_filter_params :password

        end
      end
    end

  end
end
