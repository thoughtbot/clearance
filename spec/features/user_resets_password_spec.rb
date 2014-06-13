require "spec_helper"

feature "User resets their password" do
  scenario "Can request password reset" do
    ActionMailer::Base.deliveries = []
    user = create(:user)

    visit sign_in_path
    click_on "Forgot Password"
    fill_in "Email", with: user.email
    click_on "Save Password reset"

    expect(page).to have_content("Description")
    expect(links_in_password_reset_email_for(user))
      .to include password_reset_link_for(user)
  end

  def links_in_password_reset_email_for(user)
    links_in_email(open_email(user.email))
  end

  def password_reset_link_for(user)
    password_reset = Clearance::PasswordReset.find_by!(user_id: user.id)
    edit_password_reset_url(
      user_id: password_reset.user_id,
      token: password_reset.token
    )
  end
end
