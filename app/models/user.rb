class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :picks
  has_many :players, :through => :picks
  has_attached_file :avatar, styles: { thumb: "100x100>", mini: "50x50>" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  attr_accessor :avatar_file_name, :avatar_file_size, :avatar_content_type, :avatar_updated_at

  def total_points
    players.inject(0){|points, player| points + player.points}
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def players_remaining
    players.reject{|p| p.eliminated?}.count
  end
end
