class RenameUserTeamsToPicks < ActiveRecord::Migration
  def up
    rename_table :user_teams, :picks
  end

  def down
    rename_table :picks, :user_teams
  end
end
