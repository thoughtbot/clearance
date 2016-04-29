require "spec_helper"

describe Clearance::SessionsController do
  it { should be_a Clearance::BaseController }

  describe "on GET to #new" do
    context "when a user is not signed in" do
      before { get :new }

      it { should respond_with(:success) }
      it { should render_template(:new) }
      it { should_not set_flash }
    end

    context "when a user is signed in" do
      before do
        sign_in
        get :new
      end

      it { should redirect_to(Clearance.configuration.redirect_url) }
      it { should_not set_flash }
    end
  end

  describe "on POST to #create" do
    context "when password is optional" do
      it "renders the page with error" do
        user = create(:user_with_optional_password)

        post :create, session: { email: user.email, password: user.password }

        expect(response).to render_template(:new)
        expect(flash[:alert]).to match(/^Bad email or password/)
      end
    end

    context "with good credentials" do
      before do
        @user = create(:user)
        @user.update_attribute :remember_token, "old-token"
        post :create, session: { email: @user.email, password: @user.password }
      end

      it { should redirect_to_url_after_create }

      it "sets the user in the clearance session" do
        expect(request.env[:clearance].current_user).to eq @user
      end

      it "should not change the remember token" do
        expect(@user.reload.remember_token).to eq "old-token"
      end
    end

    context "with good credentials and a session return url" do
      before do
        @user = create(:user)
        @return_url = "/url_in_the_session?foo=bar"
        @request.session[:return_to] = @return_url
        post :create, session: { email: @user.email, password: @user.password }
      end

      it "redirects to the return URL" do
        should redirect_to(@return_url)
      end
    end
  end

  describe "on DELETE to #destroy" do
    context "given a signed out user" do
      before do
        sign_out
        delete :destroy
      end

      it { should redirect_to_url_after_destroy }
    end

    context "with a cookie" do
      before do
        @user = create(:user)
        @user.update_attribute :remember_token, "old-token"
        @request.cookies["remember_token"] = "old-token"
        delete :destroy
      end

      it { should redirect_to_url_after_destroy }

      it "should reset the remember token" do
        expect(@user.reload.remember_token).not_to eq "old-token"
      end

      it "should unset the current user" do
        expect(request.env[:clearance].current_user).to be_nil
      end
    end
  end
end
