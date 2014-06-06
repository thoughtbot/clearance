require "spec_helper"

feature "User signs in" do
  scenario "with valid credentials" do
    user = create(:user)
    visit sign_in_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password_digest
    click_button "Save Session"

    expect(page).to have_content "signed in"
  end
end
