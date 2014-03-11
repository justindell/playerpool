class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :picks
  has_many :players, :through => :picks
  default_scope where(:user_id => [1, 2, 3])
  has_attached_file :avatar, styles: { thumb: "100x100>", mini: "50x50>" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def total_points
    players.inject(0){|points, player| points + player.points}
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def players_remaining
    players.reject{|p| p.eliminated?}.count
  end

  def can_edit? other
    total_points > other.total_points || self == other
  end
end
