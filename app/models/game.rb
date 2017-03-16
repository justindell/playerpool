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
    http_response = Net::HTTP.get_response(URI.parse(self.url))
    http_response = Net::HTTP.get_response(URI.parse(http_response['location'] + '/')) if http_response.is_a? Net::HTTPRedirection
    raise "ERROR: HTTP RESPONSE STATUS NOT 200: #{http_response.code} - #{http_response.body}" if http_response.code != '200'
    response = Nokogiri::HTML(http_response.body)
    away_team = response.search(".scrollingContainer a span")[0].text
    home_team = response.search(".scrollingContainer a span")[2].text
    self.away = Team.find_by(:name => away_team)
    self.home = Team.find_by(:name => home_team)
    return unless response.search('.scrollingContainer .team-score>div>div>span').count > 1
    away_points = response.search('.scrollingContainer .team-score>div>div>span')[0].text
    home_points = response.search('.scrollingContainer .team-score>div>div>span')[1].text
    response.search('.player-stats table').first.search('tbody tr').each do |p|
      parse_player(p, :away)
    end
    response.search('.player-stats table').last.search('tbody tr').each do |p|
      parse_player(p, :home)
    end
    if response.search('.scrollingContainer').last.text.match(/Final/)
      self.is_final = true
      home_points > away_points ? self.away.update_attributes!(:eliminated => true) : self.home.update_attributes!(:eliminated => true)
    end
  end

  private
  def parse_player p, team
    player = find_or_create_player(p, team)
    return unless player
    create_boxscore player, p
  end

  def find_or_create_player player_data, team
    Player.find_by(:yahoo_id => player_data.search('th a').attr('href').value.split('/').last)
  rescue
    return nil
  end

  def create_boxscore player, p
    self.boxscores << Boxscore.create!(:player => player, :points => p.search('td').last.text.to_i)
  end
end
