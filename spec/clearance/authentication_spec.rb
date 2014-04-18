require 'spec_helper'

describe Clearance::Authorization do
  class DummyController < ActionController::Base
    DummyRequest = Struct.new(:ssl?)
    include Clearance::Authentication

    def request
      DummyRequest.new(false)
    end
  end

  describe '#current_user' do
    context 'non SSL request with secure_cookie enabled' do
      it 'raises an error' do
        Clearance.stubs(configuration: configuration)
        controller = DummyController.new

        expect { controller.current_user }.
          to raise_error(RuntimeError, /secure_cookie/)
      end
    end
  end

  def configuration
    stub(secure_cookie: true)
  end
end
