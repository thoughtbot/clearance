Dummy::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = true
  config.action_controller.cache_store = :memory_store
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.active_support.deprecation = :stderr
end
