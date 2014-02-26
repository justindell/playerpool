class Pick < ActiveRecord::Base
  belongs_to :player
  belongs_to :user
  default_scope { order(:created_at) }
  validates_uniqueness_of :player_id
  validates_presence_of :player_id
end
