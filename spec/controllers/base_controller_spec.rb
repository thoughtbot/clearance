require 'spec_helper'

describe Clearance::BaseController do
  describe '#clearance_controller?' do
    it 'publicizes itself as a clearance controller' do
      should be_clearance_controller
    end
  end
end

