require 'spec_helper'

describe 'clearance route overrides' do
  around do |example|
    configure_overridden_routes

    example.run

    restore_default_config
  end

  it 'overrides the users routes' do
    expect(get: 'sign_up').to route_to("#{users_controller}#new")
    expect(post: 'users').to route_to("#{users_controller}#create")
  end

  it 'overrides the sessions routes' do
    expect(post: 'session').to route_to("#{sessions_controller}#create")
    expect(get: 'sign_in').to route_to("#{sessions_controller}#new")
    expect(delete: 'sign_out').to route_to("#{sessions_controller}#destroy")
  end

  it 'overrides the passwords routes' do
    expect(get: 'passwords/new').to route_to("#{passwords_controller}#new")
    expect(post: 'passwords').to route_to("#{passwords_controller}#create")

    expect(get: 'users/1/password/edit').to route_to(
      controller: passwords_controller,
      action: 'edit',
      user_id: '1'
    )

    expect(put: 'users/1/password').to route_to(
      controller: passwords_controller,
      action: 'update',
      user_id: '1'
    )

    expect(post: 'users/1/password').to route_to(
      controller: passwords_controller,
      action: 'create',
      user_id: '1'
    )
  end

  def configure_overridden_routes
    Clearance.configure do |config|
      config.users_controller = users_controller
      config.sessions_controller = sessions_controller
      config.passwords_controller = passwords_controller
    end

    Rails.application.reload_routes!
  end

  def users_controller
    'people'
  end

  def sessions_controller
    'admin_sessions'
  end

  def passwords_controller
    'admin_passwords'
  end

  class PeopleController < Clearance::UsersController; end
  class AdminSessionsController < Clearance::SessionsController; end
  class AdminPasswordsController < Clearance::PasswordsController; end
end
