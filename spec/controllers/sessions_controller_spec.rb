require "spec_helper"

describe Clearance::SessionsController do
  it { should be_a Clearance::BaseController }

  describe "on GET to #new" do
    context "when a user is not signed in" do
      before { get :new }

      it { should respond_with(:success) }
      it { should render_template(:new) }
      it { should_not set_the_flash }
    end

    context "when a user is signed in" do
      before do
        sign_in
        get :new
      end

      it { should redirect_to(Clearance.configuration.redirect_url) }
      it { should_not set_the_flash }
    end
  end

  describe "on POST to #create" do
    context "when password is optional" do
      it "renders the page with error" do
        user = create(:user_with_optional_password)

        post :create, session: { email: user.email, password: user.password }

        expect(response).to render_template(:new)
        expect(flash[:notice]).to match(/^Bad email or password/)
      end
    end

    context "with good credentials" do
      before do
        @user = create(:user)
        @user.update_attribute :remember_token, "old-token"
      end

      context "without configuration" do
        before do
          post :create, session: { email: @user.email, password: @user.password }
        end

        it { should redirect_to_url_after_create }

        it "sets the user in the clearance session" do
          expect(controller.current_user).to eq @user
        end

        it "should not change the remember token" do
          expect(@user.reload.remember_token).to eq "old-token"
        end
      end

      context "with configuration" do
        context "with a custom cookie name" do
          before do
            with_custom_config(:cookie_name, "custom-cookie"){
              post :create, session: { email: @user.email, password: @user.password }
            }
          end

          it "sets a custom cookie name in the header" do
            expect(response.headers["Set-Cookie"]).to match /custom-cookie=old-token/
          end
        end

        context "with cookie path set" do
          before do
            with_custom_config(:cookie_path, "/cool-page"){
              post :create, session: { email: @user.email, password: @user.password }
            }
          end
          it "sets a path cookie" do
            expect(response.headers["Set-Cookie"]).to match /path=\/cool-page/
          end
        end

        context "if httponly is set" do
          before do
            with_custom_config(:httponly, "true"){
              post :create, session: { email: @user.email, password: @user.password }
            }
          end

          it "sets a httponly cookie" do
            expect(response.headers["Set-Cookie"]).to match /HttpOnly/
          end
        end

        context "if the cookie domain is set" do
          before do
            with_custom_config(:cookie_domain, ".example.com"){
              post :create, session: { email: @user.email, password: @user.password }
            }
          end

          it "sets a domain cookie" do
            expect(response.headers["Set-Cookie"]).to match("domain=.example.com")
          end

          # There was previously a bug where two cookies would be set
          # with the same cookie name when using the domain setting
          # see: https://github.com/thoughtbot/clearance/issues/616
          it "should not set a second remember token cookie" do
            cookie_list = response.headers["Set-Cookie"].split("\n")
            expect(cookie_list.length).to be 1
          end
        end

        describe "remember token cookie expiration" do
          def format_expires(time)
            if Rails::VERSION::MAJOR > 3
              time.gmtime.rfc2822
            else
              Rack::Utils.rfc2822(time)
            end
          end

          context "default configuration" do
            before do
              post :create, session: { email: @user.email, password: @user.password }
            end

            it "is set to 1 year from now" do
              expect(response.headers["Set-Cookie"]).to match /expires=#{format_expires(1.year.from_now)}/
            end
          end

          context "configured with lambda taking one argument" do
            before do
              expiration = ->(cookies) { 12.hours.from_now }
              with_custom_config(:cookie_expiration, expiration){
                post :create, session: { email: @user.email, password: @user.password }
              }
            end

            it "it can use other cookies to set the value of the expires token" do
              expect(response.headers["Set-Cookie"]).to match /expires=#{format_expires(12.hours.from_now)}/
            end
          end
        end
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

    context "with a domain cookie" do
      before do
        with_custom_config(:cookie_domain, ".example.com"){
          user = create(:user)
          user.update_attribute :remember_token, "old-token"
          post :create, session: { email: user.email, password: user.password }
          request.cookies["remember_token"] = { value: "old-token", domain: ".example.com" }
          delete :destroy
        }
      end

      it "should delete the domain cookie" do
        expect(response.cookies["remember_token"]).to be_nil
        expect(response.headers["Set-Cookie"]).to match("domain=.example.com")
        expect(response.headers["Set-Cookie"]).to match(/Jan.1970/)
      end
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
        expect(@controller.current_user).to be_nil
      end
    end
  end

  def with_custom_config(clearance_setting, value)
    Clearance.configuration.send("#{clearance_setting}=",value)
    yield
  ensure
    restore_default_config
  end
end
