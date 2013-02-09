class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user
      t.string :user_name
      t.text :body

      t.timestamps
    end
    add_index :messages, :user_id
  end
end
