class Player < ActiveRecord::Base
  belongs_to :team
  has_and_belongs_to_many :users
  has_many :boxscores, :dependent => :destroy

  validates_uniqueness_of :yahoo_id

  def full_name
    "#{first_name} #{last_name}"
  end

  def eliminated?
    team.eliminated
  end

  def team_name
    team.to_s
  end

  def points
    boxscores.inject(0){|acc, box| acc + box.points}
  end
end
