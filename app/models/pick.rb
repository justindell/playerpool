class Pick < ActiveRecord::Base
  belongs_to :player
  belongs_to :user
  default_scope { order(:created_at) }
  validates_uniqueness_of :player_id
  validates_presence_of :player_id
  validate :users_turn_to_pick

  private
  def users_turn_to_pick
    pick_count, user_count = Pick.count, User.count
    round = (pick_count / user_count).to_i + 1
    turn = pick_count % user_count
    valid = round.odd? ? (turn + 1 == user.draft_position) : (turn == user_count - user.draft_position)
    errors.add(:base, "Wait for your turn!") unless valid
  end
end
