require "spec_helper"

describe "Clearance::Controller", type: :controller do
  controller(ActionController::Base) do
    include Clearance::Controller
  end

  it "does not expose any action_methods" do
    expect(controller.action_methods).to be_empty
  end
end
