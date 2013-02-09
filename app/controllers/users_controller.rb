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
  end

  def add_player
    @user = User.find(params[:id])
    @user.players << Player.find(params[:player_id])

    redirect_to(edit_user_url(@user), :notice => 'Player added successfully')
  end
end
