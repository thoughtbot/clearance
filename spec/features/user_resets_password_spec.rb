require "spec_helper"

feature "User resets their password" do
  scenario "can request password reset" do
    ActionMailer::Base.deliveries = []
    user = create(:user)

    visit sign_in_path
    click_on "Forgot Password"
    fill_in "Email", with: user.email
    click_on "Create"

    expect(page).to have_content("Description")
    expect(links_in_password_reset_email_for(user))
      .to include password_reset_link_for(user)
  end

  scenario "can complete password reset" do
    password_reset = create(:password_reset)
    new_password = "new_password"

    visit edit_user_password_reset_path(password_reset.user, password_reset)
    fill_in "Password", with: new_password
    click_on "Update Password reset"

    expect(page).to have_content "signed in"
    expect(password_reset.user.reload.password_digest).to eq new_password
  end

  def links_in_password_reset_email_for(user)
    links_in_email(open_email(user.email))
  end

  def password_reset_link_for(user)
    password_reset = PasswordReset.find_by!(user_id: user.id)
    edit_user_password_reset_url(password_reset.user, password_reset)
  end
end
