module Clearance
  module Authorization
    extend ActiveSupport::Concern

    included do
      private :deny_access, :require_login
    end

    # Use as a `before_action` to require a user be signed in to proceed.
    # {Authentication#signed_in?} is used to determine if there is a signed in
    # user or not.
    #
    #     class PostsController < ApplicationController
    #       before_action :require_login
    #
    #       def index
    #         # ...
    #       end
    #     end
    def require_login
      unless signed_in?
        deny_access(I18n.t("flashes.failure_when_not_signed_in"))
      end
    end

    # Responds to unauthorized requests in a manner fitting the request format.
    # `js`, `json`, and `xml` requests will receive a 401 with no body. All
    # other formats will be redirected appropriately and can optionally have the
    # flash message set.
    #
    # When redirecting, the originally requested url will be stored in the
    # session (`session[:return_to]`), allowing it to be used as a redirect url
    # once the user has successfully signed in.
    #
    # If there is a signed in user, the request will be redirected according to
    # the value returned from {#url_after_denied_access_when_signed_in}.
    #
    # If there is no signed in user, the request will be redirected according to
    # the value returned from {#url_after_denied_access_when_signed_out}.
    # For the exact redirect behavior, see {#redirect_request}.
    #
    # @param [String] flash_message
    def deny_access(flash_message = nil)
      respond_to do |format|
        format.any(:js, :json, :xml) { head :unauthorized }
        format.any { redirect_request(flash_message) }
      end
    end

    protected

    # @api private
    def redirect_request(flash_message)
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

    # @api private
    def clear_return_to
      session[:return_to] = nil
    end

    # @api private
    def store_location
      if request.get?
        session[:return_to] = request.original_fullpath
      end
    end

    # @api private
    def redirect_back_or(default)
      redirect_to(return_to || default)
      clear_return_to
    end

    # @api private
    def return_to
      if return_to_url
        uri = URI.parse(return_to_url)
        "#{uri.path}?#{uri.query}".chomp('?')
      end
    end

    # @api private
    def return_to_url
      session[:return_to]
    end

    # Used as the redirect location when {#deny_access} is called and there is a
    # currently signed in user.
    #
    # @return [String]
    def url_after_denied_access_when_signed_in
      Clearance.configuration.redirect_url
    end

    # Used as the redirect location when {#deny_access} is called and there is
    # no currently signed in user.
    #
    # @return [String]
    def url_after_denied_access_when_signed_out
      sign_in_url
    end
  end
end
