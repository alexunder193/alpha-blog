class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?

  #if I put this method here is accessible from controllers
  #if I put helper_method it's also a helper method which I moved from application_helper.rb
  def current_user
    #memoization
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    #make it boolean
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:alert] = "You must be logged in to perform that action"
      redirect_to login_path
    end
  end

end
