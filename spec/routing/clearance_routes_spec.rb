require 'spec_helper'

describe 'routes for Clearance' do
  context 'signup disabled' do
    before(:all) do
      Clearance.configure do |config|
        config.allow_sign_up = false
      end

      Rails.application.reload_routes!
    end

    after :all do
      Clearance.configuration = Clearance::Configuration.new
      Rails.application.reload_routes!
    end

    it 'does not route sign_up' do
      expect(get: 'sign_up').not_to be_routable
    end

    it 'does not route to users#create' do
      expect(post: 'users').not_to be_routable
    end

    it 'does not route to users#new' do
      expect(get: 'users/new').not_to be_routable
    end
  end

  context 'signup enabled' do
    it 'does route sign_up' do
      expect(get: 'sign_up').to be_routable
    end

    it 'does route to users#create' do
      expect(post: 'users').to be_routable
    end
  end
end
