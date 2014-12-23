require "spec_helper"
include FakeModelWithoutPasswordStrategy

describe "Password strategy configuration" do
  describe "when Clearance.configuration.password_strategy is set" do
    it "includes the value it is set to" do
      mock_password_strategy = Module.new

      Clearance.configuration.password_strategy = mock_password_strategy

      expect(model_instance).to be_kind_of(mock_password_strategy)
    end
  end

  describe "when Clearance.configuration.password_strategy is not set" do
    it "includes Clearance::PasswordStrategies::BCrypt" do
      Clearance.configuration.password_strategy = nil

      expect(model_instance).to be_kind_of(
        Clearance::PasswordStrategies::BCrypt
      )
    end
  end

  def model_instance
    fake_model_without_password_strategy
  end
end
