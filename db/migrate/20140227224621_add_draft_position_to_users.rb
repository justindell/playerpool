class AddDraftPositionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :draft_position, :integer
  end
end
