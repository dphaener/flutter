class RelationshipsController < ApplicationController

  before_action :authenticate_user!, :set_followed_user

  def create
    current_user.follow(@followed_user)    
    redirect_to profile_url(@followed_user)
  end

private

  def set_followed_user
    @followed_user = User.find_by(screen_name: params[:screen_name]) || not_found!
  end
end
