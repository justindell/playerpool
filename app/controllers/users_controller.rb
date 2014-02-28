class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.order(:draft_position)

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
    @team = @user.picks.includes(:player => :boxscores)
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to(root_url, notice: 'User was successfully updated.')
    else
      render action: 'edit'
    end
  end

  def update_all
    params[:users].each_with_index do |user, index|
      User.find(user).update_attributes! :draft_position => index + 1
    end
    render :nothing => true
  end

  private
  def user_params
    params.require(:user).permit!
  end
end
