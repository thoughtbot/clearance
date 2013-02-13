module FakeModelWithPasswordStrategy
  def fake_model_with_password_strategy(password_strategy)
    Class.new do
      attr_reader :password
      attr_accessor :encrypted_password, :salt

      include password_strategy
    end.new
  end
end

RSpec.configure do |config|
  config.include FakeModelWithPasswordStrategy
end
