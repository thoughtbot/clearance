if defined?(ActionController)
  module ActionController
    class Forbidden < StandardError
    end
  end
end
