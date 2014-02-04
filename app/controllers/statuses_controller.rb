class StatusesController < ApplicationController
  
  before_action :authenticate_user!, except: [:index]

  def index
    @statuses = Status.all
  end

  def new
    @status = Status.new
  end

  def create
    @status = current_user.statuses.new(status_params)
    if @status.save
      redirect_to statuses_url, notice: "Status updated"
    else
      render "new"
    end
  end

private

  def status_params
    params.require(:status).permit(:text)
  end
end