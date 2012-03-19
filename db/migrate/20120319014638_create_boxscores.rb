class CreateBoxscores < ActiveRecord::Migration
  def self.up
    create_table :boxscores do |b|
      b.integer :player_id
      b.integer :game_id
      b.integer :points

      b.timestamps
    end

    remove_column :players, :points
    add_index :boxscores, :player_id
  end

  def self.down
    drop_table :boxscores
    add_column :players, :points, :integer
  end
end
