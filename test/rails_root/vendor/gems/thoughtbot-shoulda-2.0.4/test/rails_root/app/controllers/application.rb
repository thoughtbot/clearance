# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_rails_root_session_id'
  
  def ensure_logged_in
    unless session[:logged_in]
      respond_to do |accepts|
        accepts.html do
          flash[:error] = 'What do you think you\'re doing?'
          redirect_to '/'
        end
        accepts.xml do
          headers["Status"]           = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "Couldn't authenticate you", :status => '401 Unauthorized'
        end
      end
      return false
    end
    return true
  end
end
