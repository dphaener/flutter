class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :logout, :make_links

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

  def logout
    session.delete(:user_id)
  end

  def authenticate_user!
    redirect_to new_session_url unless logged_in?
  end

  def not_found!
    raise ActionController::RoutingError.new("Not Found")
  end
  
  def make_links(status, users)
    users.each do |user|
      status.gsub!("@#{user}", "<a href=\"/#{user}\">@#{user}</a>")
    end
    return status
  end
end
