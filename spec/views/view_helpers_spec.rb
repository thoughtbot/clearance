require "spec_helper"

describe "Clearance RSpec view spec configuration", type: :view do
  it "lets me use clearance's helper methods in view specs" do
    user = double("User")
    sign_in_as(user)

    expect(view.current_user).to eq user
  end
end
