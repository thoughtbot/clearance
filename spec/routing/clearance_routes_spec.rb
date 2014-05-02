require 'spec_helper'

describe 'routes for Clearance' do
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
      expect(post: 'sessions').not_to be_routable
      expect(post: 'passwords').not_to be_routable
      expect(post: 'users').not_to be_routable
    end
  end
end
