require "spec_helper"

feature "User signs out" do
  scenario "signs out" do
    sign_in
    sign_out

    user_should_be_signed_out
  end
end
