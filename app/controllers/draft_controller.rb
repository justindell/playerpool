class DraftController < ApplicationController
  before_filter :auth_user!

  def index
    @users = User.includes(:players => :team).order(:draft_position)
    @picks = Pick.includes(:player, :user)
    @messages = Message.all
    render :layout => false
  end
end
