module Clearance
  module Test
    module Functional
      module UsersControllerTest

        def self.included(controller_test)
          controller_test.class_eval do
            
            should_filter_params :password
            
            public_context do
              context "When getting new User view" do
                setup { get :new }
                
                should_respond_with :success
                should_render_template :new
                should_not_set_the_flash
                
                should "display a form to register" do
                 assert_select "form[action=#{users_path}][method=post]", 
                  true, "There must be a form to register" do
                    assert_select "input[type=text][name=?]", 
                      "user[email]", true, "There must be an email field"
                    assert_select "input[type=password][name=?]", 
                      "user[password]", true, "There must be a password field"
                    assert_select "input[type=password][name=?]", 
                      "user[password_confirmation]", true, "There must be a password confirmation field"                      
                    assert_select "input[type=submit]", true, 
                      "There must be a submit button"
                 end
                end
              end
              
              context "Given email parameter when getting new User view" do
                setup do
                  @email = "a@example.com"
                  get :new, :user => { :email => @email }
                end

                should "set assigned user's email" do
                  assert_equal @email, assigns(:user).email
                end
              end

              context "Given valid attributes when creating a new user" do
                setup do
                  user_attributes = Factory.attributes_for(:registered_user)
                  post :create, :user => user_attributes
                end
            
                should_create_user_successfully
              end
            end

            signed_in_user_context do
              context "GET to new" do
                setup { get :new }
                should_redirect_to "root_url"
              end

              context "POST to create" do
                setup { post :create, :user => {} }
                should_redirect_to "root_url"
              end
            end
          
          end
        end
      end
    end
  end
end
