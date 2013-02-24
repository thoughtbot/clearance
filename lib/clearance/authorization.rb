module Clearance
  module Authorization
    extend ActiveSupport::Concern

    included do
      hide_action :authorize, :deny_access
    end

    def authorize
      unless signed_in?
        deny_access
      end
    end

    def deny_access(flash_message = nil)
      store_location

      if flash_message
        flash[:notice] = flash_message
      end

      if signed_in?
        redirect_to url_after_denied_access_when_signed_in
      else
        redirect_to url_after_denied_access_when_signed_out
      end
    end

    protected

    def clear_return_to
      session[:return_to] = nil
    end

    def store_location
      if request.get?
        session[:return_to] = request.fullpath
      end
    end

    def redirect_back_or(default)
      redirect_to(return_to || default)
      clear_return_to
    end

    def redirect_to_root
      redirect_to('/')
    end

    def return_to
      session[:return_to] || params[:return_to]
    end

    def url_after_denied_access_when_signed_in
      '/'
    end

    def url_after_denied_access_when_signed_out
      sign_in_url
    end
  end
end
