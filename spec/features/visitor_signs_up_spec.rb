require "spec_helper"

feature "Visitor signs up" do
  scenario "with an email and password" do
    visit sign_up_path
    fill_in "user_email", with: "email@example.com"
    fill_in "user_password", with: "password"
    click_on "Create"

    expect(page).to have_content("signed in")
  end
end
