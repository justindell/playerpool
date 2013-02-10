class PlayerPoolController < ApplicationController
  before_filter :auth_user!, :only => :index

  def index
    @users = User.includes(:players => [:boxscores, :team]).sort_by{|u| u.total_points}.reverse
  end

  def refresh
    raise "must specify a date (YYYY-MM-DD)" unless params[:date]
    Refresher.refresh params[:date]
    if params[:user_id]
      @user = User.find(params[:user_id])
      render :partial => 'users/players'
    else
      @users = User.includes(:players => [:boxscores, :team]).sort_by{|u| u.total_points}.reverse
      render :partial => 'standings'
    end
  end
end
