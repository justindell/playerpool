class AddYahooIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :yahoo_id, :integer
  end
end
