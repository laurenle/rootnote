class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method def logged_in?
    session[:user_id]
  end

  helper_method def current_user
    @user ||= User.find(session[:user_id]) if logged_in?
  end

  before_filter :require_login

  private

  def require_login
    redirect_to login_url unless current_user
  end
end
