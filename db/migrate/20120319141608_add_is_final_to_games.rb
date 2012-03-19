class AddIsFinalToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :is_final, :boolean
  end

  def self.down
    remove_column :games, :is_final
  end
end
