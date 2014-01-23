class SessionsController < ApplicationController
  before_action :redirect_if_logged_in

  def create
    if user = User.authenticate(params[:email], params[:password])
      login_as(user)
      redirect_to statuses_url
    else
      flash.now[:alert] = "Invalid email or password!"
      render "new"
    end
  end

private

  def redirect_if_logged_in
    redirect_to statuses_url if logged_in?
  end
end
