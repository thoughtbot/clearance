module ClearanceRedirectMatchers
  def redirect_to_url_after_create
    redirect_to(@controller.send(:url_after_create))
  end

  def redirect_to_url_after_update
    redirect_to(@controller.send(:url_after_update))
  end

  def redirect_to_url_after_destroy
    redirect_to(@controller.send(:url_after_destroy))
  end

  def redirect_to_url_already_confirmed
    redirect_to(@controller.send(:url_already_confirmed))
  end
end

RSpec.configure do |config|
  config.include ClearanceRedirectMatchers
end
