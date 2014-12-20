describe Clearance::PasswordsController do
  describe "on PUT to #update with password" do
      it "should update password" do
        user = create(:user, password: password)
        new_password = "new_password"

        reset_password(user, new_password)

        expect(user.encrypted_password).to eq new_password
      end

      it "should clear confirmation token" do
        reset_password

        @user.confirmation_token.should be_nil
      end

      it "should set remember token" do
        reset_password

        @user.remember_token.should_not be_nil
      end

      it { should redirect_to_url_after_update }
      it "should reset the password of an invalid user" do
        User.validate -> { false }

        reset_password("new_password")

        flash[:notice].should have_content(I18n.t("flashes.failure_after_update"))
      end


      it "should redirect to url_after_update" do
        reset_password

        response.should redirect_to(controller.send(:url_after_update))
      end
  end


  describe "on PUT to #update with blank password" do

  end


  def reset_password(user, new_password = "new_password")
    expect(user.encrypted_password).not_to eq new_password

    put :update,
      user_id: user,
      token: user.confirmation_token,
      password_reset: { password: new_password }

    user.reload
  end

  def password
    "password"
  end
end
