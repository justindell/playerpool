class DraftController < ApplicationController
  def index
    @users = User.includes(:players => :team)
    @messages = Message.all
    render :layout => false
  end
end
