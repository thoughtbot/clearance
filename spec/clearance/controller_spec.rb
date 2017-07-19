require "spec_helper"

describe Clearance::Controller, type: :controller do
  context "included within ActionController::Base" do
    controller(ActionController::Base) do
      include Clearance::Controller
    end

    it "exposes no action methods" do
      expect(controller.action_methods).to be_empty
    end
  end

  if defined?(ActionController::API)
    context "included within ActionController::API" do
      controller(ActionController::API) do
        include Clearance::Controller
      end

      it "exposes no action methods" do
        expect(controller.action_methods).to be_empty
      end
    end
  end
end
