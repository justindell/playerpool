class Team < ActiveRecord::Base
  has_many :players, :dependent => :destroy
  has_many :games

  validates_uniqueness_of :code

  def to_s
    self.name
  end
end
