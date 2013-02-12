class PicksController < ApplicationController
  def create
    @pick = Pick.new(params[:pick])

    if @pick.save
      full_attributes = @pick.attributes.merge(
        :player_name => @pick.player.full_name,
        :user_name => @pick.user.full_name,
        :team_name => @pick.player.team.to_s)

      Pusher['draft'].trigger('pick', full_attributes)

      respond_to do |format|
        format.html { redirect_to edit_user_url(@pick.user_id), :notice => 'Player Added' }
        format.json { render :json => @pick, :status => :created }
      end
    else
      redirect_to :back, :alert => 'There was an error adding the player'
    end
  end

  def destroy
    team = Pick.destroy params[:id]
    redirect_to edit_user_url(team.user_id), :notice => 'Player Removed'
  end
end
