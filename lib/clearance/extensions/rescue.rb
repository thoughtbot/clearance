if defined?(ActionDispatch::ShowExceptions) # Rails 3
  ActionDispatch::ShowExceptions.rescue_responses.update('ActionController::Forbidden' => :forbidden)
elsif defined?(ActionController::Base)
  ActionController::Base.rescue_responses.update('ActionController::Forbidden' => :forbidden)
end
