require "spec_helper"

describe "Clearance RSpec helper spec configuration", type: :helper do
  it "lets me use clearance's helper methods in helper specs" do
    user = double("User")
    sign_in_as(user)

    expect(helper.current_user).to eq user
  end
end
