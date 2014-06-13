Dummy::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = true
  config.action_controller.cache_store = :memory_store
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.active_support.deprecation = :stderr
  config.action_mailer.delivery_method = :test
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: 'www.example.com' }

  config.middleware.insert_after Warden::Manager, Clearance::BackDoor
end
