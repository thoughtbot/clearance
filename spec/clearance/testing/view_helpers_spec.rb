require "spec_helper"

describe Clearance::Testing::ViewHelpers do
  describe "#sign_in" do
    it "sets the signed in user to a new user object" do
      user_model = Class.new
      allow(Clearance.configuration).to receive(:user_model).
        and_return(user_model)

      view = test_view_class.new
      view.sign_in

      expect(view.current_user).to be_an_instance_of(user_model)
    end
  end

  describe "#sign_in_as" do
    it "sets the signed in user to the object provided" do
      user = double("User")

      view = test_view_class.new
      view.sign_in_as(user)

      expect(view.current_user).to eq user
    end
  end

  def test_view_class
    Class.new do
      include Clearance::Testing::ViewHelpers

      def view
        @view ||= extend Clearance::Testing::ViewHelpers::CurrentUser
      end
    end
  end
end
