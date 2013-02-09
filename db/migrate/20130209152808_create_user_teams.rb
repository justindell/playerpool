class CreateUserTeams < ActiveRecord::Migration
  def change
    create_table :user_teams do |t|
      t.references :player
      t.references :user

      t.timestamps
    end
    add_index :user_teams, :user_id
    add_index :user_teams, :player_id

    drop_table :players_users
  end
end
