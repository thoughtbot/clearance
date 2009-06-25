if defined?(ActionController::Base)
  ActionController::Base.rescue_responses.update('ActionController::Forbidden' => :forbidden)
end
