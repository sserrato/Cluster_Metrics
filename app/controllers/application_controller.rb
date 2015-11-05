class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

def authenticate
  unless logged_in?
    flash[:error] = "Please login first."
    redirect_to root_path
  end
end

def admin_only
    unless logged_in? && current_user.access_permission > 0
      flash[:error] = "Restricted Access to SAT Admins Only"
      redirect_to root_path
    end
  end
end
