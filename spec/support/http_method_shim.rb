# Rails 5 deprecates calling HTTP action methods with positional arguments
# in favor of keyword arguments. However, the keyword argument form is only
# supported in Rails 5+. Since we support back to 3.1, we need some sort of shim
# to avoid super noisy deprecations when running tests.
module HTTPMethodShim5
  def get(path, params=nil, headers=nil)
    super(path, params: params, headers: headers)
  end

  def put(path, params=nil, headers=nil)
    super(path, params: params, headers: headers)
  end

  def post(path, params=nil, headers=nil)
    super(path, params: params, headers: headers)
  end
end

# Positional arguments are fully deprecated in 5.1+ but we need
# to carry on supporting the exising tests, lets shim it.
module HTTPMethodShim51
  def get(path, *args)
    super(path, params: args)
  end

  def put(path, *args)
    super(path, params: args)
  end

  def post(path, *args)
    super(path, params: args)
  end
end

RSpec.configure do |config|
  if Rails::VERSION::MAJOR >= 5 && Rails::VERSION::MINOR < 1
    config.include HTTPMethodShim5, type: [:controller]
  elsif Rails::VERSION::MAJOR >= 5 && Rails::VERSION::MINOR >= 1
    [:controller, :request].each do |type|
      config.include HTTPMethodShim51, type: type
    end
  end
end
