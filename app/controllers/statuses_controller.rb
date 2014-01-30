class StatusesController < ApplicationController
  
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @statuses = Status.all.order("created_at DESC")
  end

  def new
    @status = Status.new
  end

  def create
    if current_user.statuses.create(status_params)
      redirect_to statuses_url
    else
      render "new"
    end
  end

private

  def status_params
    params.require(:status).permit(:text)
  end
end