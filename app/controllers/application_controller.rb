class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def login_as(user)
    session[:user_id] = user.id
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by(:id => session[:user_id])
  end

  def logged_in?
    current_user.present?
  end
end
