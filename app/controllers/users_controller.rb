class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      login_as(@user)
      redirect_to statuses_url, :notice => "Welcome!"
    else
      render "new"
    end
  end

private

  def user_params
    params.require(:user).permit(:screen_name, :full_name, :url, :email, :password)
  end
end