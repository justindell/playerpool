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
    away_team = response.search("#mediamodulematchheadergrandslam .teams-container .team.away a").last.to_html
    home_team = response.search("#mediamodulematchheadergrandslam .teams-container .team.home a").last.to_html
    self.away = Team.create_with(:name => away_team.match(/\">(.*)<\/a>/)[1]).find_or_create_by(:code => away_team.match(/teams\/(.*)\/\"/)[1])
    self.home = Team.create_with(:name => home_team.match(/\">(.*)<\/a>/)[1]).find_or_create_by(:code => home_team.match(/teams\/(.*)\/\"/)[1])
    away_points = response.search('#mediamodulematchheadergrandslam .teams-container .boxscore .score').first.inner_html.to_i
    home_points = response.search('#mediamodulematchheadergrandslam .teams-container .boxscore .score').last.inner_html.to_i
    response.search('#mediasportsmatchstatsbyplayer table.yom-data').first.search('tbody tr').each do |p|
      parse_player(p, :away)
    end
    response.search('#mediasportsmatchstatsbyplayer table.yom-data').last.search('tbody tr').each do |p|
      parse_player(p, :home)
    end
    if response.search('#mediamodulematchheadergrandslam .teams-container .final').length > 0
      self.is_final = true
      home_points > away_points ? self.away.update_attributes!(:eliminated => true) : self.home.update_attributes!(:eliminated => true)
    end
  end

  private
  def parse_player p, team
    player_data = p.search('.athlete a').to_html
    return if player_data.blank?
    create_boxscore find_or_create_player(player_data, team), p
  end

  def find_or_create_player player_data, team
    Player.create_with(:first_name => player_data.match(/>(.*) (.*)<\/a>/)[1],
                       :last_name => player_data.match(/>(.*) (.*)<\/a>/)[2],
                       :team_id => self.send(team).to_param).
           find_or_create_by(:yahoo_id => player_data.match(/[0-9]+/)[0])
  end

  def create_boxscore player, p
    self.boxscores << Boxscore.create!(:player => player, :points => p.search('td').last.inner_html.to_i)
  end
end
