class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  has_many :user_teams
  has_many :players, :through => :user_teams

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
