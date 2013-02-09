class Player < ActiveRecord::Base
  belongs_to :team
  has_many :user_teams
  has_many :users, :through => :user_teams
  has_many :boxscores, :dependent => :destroy

  validates_uniqueness_of :yahoo_id

  def full_name
    "#{first_name} #{last_name}"
  end

  def eliminated?
    team.eliminated
  end

  def playing?
    boxscores.any?{ |b| !b.game.is_final }
  end

  def team_name
    team.to_s
  end

  def points
    boxscores.inject(0){|acc, box| acc + box.points}
  end
end
