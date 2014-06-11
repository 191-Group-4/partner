class VisitorsController < ApplicationController
  def index
  	  @users = User.all
  #@user = User.find(params[:id])
  authorize @users

  end
end
