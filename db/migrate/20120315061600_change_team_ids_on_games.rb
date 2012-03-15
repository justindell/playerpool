class ChangeTeamIdsOnGames < ActiveRecord::Migration
  def self.up
    remove_column :games, :home
    remove_column :games, :away
    add_column :games, :home_id, :integer
    add_column :games, :away_id, :integer
  end

  def self.down
    remove_column :games, :home_id
    remove_column :games, :away_id
    add_column :games, :home, :string
    add_column :games, :away, :string
  end
end
