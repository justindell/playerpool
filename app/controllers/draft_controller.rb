class DraftController < ApplicationController
  def index
    @users = User.includes(:players => :team)
    @picks = Pick.includes(:player, :user)
    @messages = Message.all
    render :layout => false
  end
end
