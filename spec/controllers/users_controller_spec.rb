require "spec_helper"

describe Clearance::UsersController do
  it { should be_a Clearance::BaseController }

  describe "on GET to #new" do
    context "when signed out" do
      it "renders a form for a new user" do
        get :new

        expect(response).to be_success
        expect(response).to render_template(:new)
      end

      it "defaults email field to the value provided in the query string" do
        get :new, user: { email: "a@example.com" }

        expect(assigns(:user).email).to eq "a@example.com"
        expect(response).to be_success
        expect(response).to render_template(:new)
      end
    end

    context "when signed in" do
      it "redirects to the configured clearance redirect url" do
        sign_in

        get :new

        expect(response).to redirect_to(Clearance.configuration.redirect_url)
      end
    end
  end

  describe "on POST to #create" do
    context "when signed out" do
      context "with valid attributes" do
        it "assigns and creates a user then redirects to the redirect_url" do
          user_attributes = FactoryGirl.attributes_for(:user)
          old_user_count = User.count

          post :create, user: user_attributes

          expect(assigns(:user)).to be_present
          expect(User.count).to eq old_user_count + 1
          expect(response).to redirect_to(Clearance.configuration.redirect_url)
        end
      end

      context "with valid attributes and a session return url" do
        it "assigns and creates a user then redirects to the return_url" do
          user_attributes = FactoryGirl.attributes_for(:user)
          old_user_count = User.count
          return_url = "/url_in_the_session"
          @request.session[:return_to] = return_url

          post :create, user: user_attributes

          expect(assigns(:user)).to be_present
          expect(User.count).to eq old_user_count + 1
          expect(response).to redirect_to(return_url)
        end
      end
    end

    context "when signed in" do
      it "redirects to the configured clearance redirect url" do
        sign_in

        post :create, user: {}

        expect(response).to redirect_to(Clearance.configuration.redirect_url)
      end
    end
  end
end
