class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

  def show
    @user = User.find_by(screen_name: params[:screen_name]) || not_found!
  end

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

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to edit_user_url, notice: "Attributes updated succesfully"
    else
      render "edit"
    end
  end

private

  def user_params
    params.require(:user).permit(:screen_name, :full_name, :url, :email, :password)
  end
end