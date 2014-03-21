require 'spec_helper'

describe 'routes for Clearance' do
  context 'routes enabled' do
    it 'draws the default routes' do
      expect(get: 'sign_up').to be_routable
      expect(get: 'sign_in').to be_routable
      expect(get: 'passwords/new').to be_routable
      expect(post: 'session').to be_routable
      expect(post: 'passwords').to be_routable
      expect(post: 'users').to be_routable
    end
  end

  context 'routes disabled' do
    around do |example|
      Clearance.configure { |config| config.routes = false }
      Rails.application.reload_routes!
      example.run
      Clearance.configuration = Clearance::Configuration.new
      Rails.application.reload_routes!
    end

    it 'does not draw any routes' do
      expect(get: 'sign_up').not_to be_routable
      expect(get: 'sign_in').not_to be_routable
      expect(get: 'passwords/new').not_to be_routable
      expect(post: 'session').not_to be_routable
      expect(post: 'passwords').not_to be_routable
      expect(post: 'users').not_to be_routable
    end
  end

  context 'signup disabled' do
    around do |example|
      Clearance.configure { |config| config.allow_sign_up = false }
      Rails.application.reload_routes!
      example.run
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
