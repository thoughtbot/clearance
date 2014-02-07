require 'spec_helper'

describe Clearance::Testing::Helpers do
  class TestClass
    include Clearance::Testing::Helpers

    def initialize
      @controller = Controller.new
    end

    class Controller
      def sign_in(user); end
    end
  end

  describe '#sign_in' do
    it 'creates an instance of the clearance user model with FactoryGirl' do
      MyUserModel = Class.new
      FactoryGirl.stubs(:create)
      Clearance.configuration.stubs(user_model: MyUserModel)

      TestClass.new.sign_in

      expect(FactoryGirl).to have_received(:create).with(:my_user_model)
    end
  end
end
