class Pick < ActiveRecord::Base
  belongs_to :player
  belongs_to :user
  default_scope { order(:created_at) }
  validates_uniqueness_of :player_id
  validates_presence_of :player_id
  validate :users_turn_to_pick

  def self.current_pick
    pick_count, user_count = Pick.count, User.count
    round = (pick_count / user_count).to_i + 1
    turn = pick_count % user_count
    valid = round.odd? ? turn + 1 : user_count - turn
  end

  private
  def users_turn_to_pick
    errors.add(:base, "Wait for your turn!") unless user.draft_position == Pick.current_pick
  end
end
