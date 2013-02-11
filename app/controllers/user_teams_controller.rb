class UserTeamsController < ApplicationController
  def create
    @user_team = UserTeam.new(params[:user_team])

    if @user_team.save
      full_attributes = @user_team.attributes.merge(
        :player_name => @user_team.player.full_name,
        :user_name => @user_team.user.full_name,
        :team_name => @user_team.player.team.to_s)

      Pusher['draft'].trigger('pick', full_attributes)

      respond_to do |format|
        format.html { redirect_to edit_user_url(@user_team.user_id), :notice => 'Player Added' }
        format.json { render :json => @user_team, :status => :created }
      end
    else
      redirect_to :back, :alert => 'There was an error adding the player'
    end
  end

  def destroy
    team = UserTeam.destroy params[:id]
    redirect_to edit_user_url(team.user_id), :notice => 'Player Removed'
  end
end
