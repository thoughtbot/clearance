require "spec_helper"

feature "User signs out" do
  scenario "successfully" do
    user = create(:user)

    visit root_path(as: user)
    click_link "Sign out"

    expect(page).to have_content "GUEST"
  end
end
