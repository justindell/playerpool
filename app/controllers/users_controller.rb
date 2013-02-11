class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.includes(:players => [:team, :boxscores]).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @team = @user.user_teams.includes(:player => :boxscores)
  end
end
