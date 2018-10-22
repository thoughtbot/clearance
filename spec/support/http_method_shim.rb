# Rails 5 deprecates calling HTTP action methods with positional arguments
# in favor of keyword arguments. However, the keyword argument form is only
# supported in Rails 5+. Since we support 4.2, we must give it a shim to massage
# the params into the previous style!

module PreRailsFiveHTTPMethodShim
  def get(path, params: {}, headers: {}, format: :html)
    super(path, params.merge(format: format), headers)
  end

  def put(path, params: {}, headers: {}, format: :html)
    super(path, params.merge(format: format), headers)
  end

  def post(path, params: {}, headers: {}, format: :html)
    super(path, params.merge(format: format), headers)
  end
end

if Rails::VERSION::MAJOR < 5
  RSpec.configure do |config|
    config.include PreRailsFiveHTTPMethodShim, type: :controller
    config.include PreRailsFiveHTTPMethodShim, type: :request
  end
end
