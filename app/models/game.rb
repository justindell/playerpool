require 'net/http'
require 'uri'

class Game < ActiveRecord::Base
  before_create :fetch_game_attributes
  validates_uniqueness_of :url
  belongs_to :home, :class_name => 'Team'
  belongs_to :away, :class_name => 'Team'
  has_many :boxscores, :dependent => :destroy

  def fetch_game_attributes
    Rails.logger.info "fetching game attributes for #{self.url}"
    data = JSON.parse(open(url).read)
    self.away = Team.find_by(yahoo_id: data['service']['boxscore']['game']['away_team_id'].match(/\d+/)[0])
    self.home = Team.find_by(yahoo_id: data['service']['boxscore']['game']['home_team_id'].match(/\d+/)[0])
    away_points = data['service']['boxscore']['game']['total_away_points'].to_i
    home_points = data['service']['boxscore']['game']['total_home_points'].to_i
    (data['service']['boxscore']['player_stats'] || []).each do |player, stat|
      parse_player(player, stat)
    end
    if data['service']['boxscore']['game']['status_type'] == 'status.type.final'
      self.is_final = true
      home_points > away_points ? self.away.update_attributes!(:eliminated => true) : self.home.update_attributes!(:eliminated => true)
    end
  end

  private
  def parse_player p, stat
    player = Player.find_by(:yahoo_id => p.match(/\d+/)[0])
    return unless player
    self.boxscores << Boxscore.create!(:player => player, :points => stat['ncaab.stat_variation.2']['ncaab.stat_type.13'].to_i)
  end
end
