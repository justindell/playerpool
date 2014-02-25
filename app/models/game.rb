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
    http_response = Net::HTTP.get_response(URI.parse(http_response['location'])) if http_response.is_a? Net::HTTPRedirection 
    raise "ERROR: HTTP RESPONSE STATUS NOT 200: #{http_response.code} - #{http_response.body}" if http_response.code != '200'
    response = Nokogiri::HTML(http_response.body)
    away_team = response.search("#mediamodulematchheadergrandslam .teams-container .team.away a").last.to_html
    home_team = response.search("#mediamodulematchheadergrandslam .teams-container .team.home a").last.to_html
    self.away = Team.find_or_create_by_code(:code => away_team.match(/teams\/(.*)\/\"/)[1], :name => away_team.match(/\">(.*)<\/a>/)[1])
    self.home = Team.find_or_create_by_code(:code => home_team.match(/teams\/(.*)\/\"/)[1], :name => home_team.match(/\">(.*)<\/a>/)[1])
    away_points = response.search('#mediamodulematchheadergrandslam .teams-container .boxscore .score').first.inner_html.to_i
    home_points = response.search('#mediamodulematchheadergrandslam .teams-container .boxscore .score').last.inner_html.to_i
    response.search('#mediasportsmatchstatsbyplayer table.yom-data').first.search('tbody tr').each do |p|
      player_data = p.search('.athlete a').to_html
      next if player_data.blank?
      player = Player.find_or_create_by_yahoo_id(:yahoo_id => player_data.match(/[0-9]+/)[0],
                                                 :first_name => player_data.match(/>(.*) (.*)<\/a>/)[1],
                                                 :last_name => player_data.match(/>(.*) (.*)<\/a>/)[2],
                                                 :team_id => self.away.to_param)
      self.boxscores << Boxscore.create!(:player => player, :points => p.search('td').last.inner_html.to_i)
    end
    response.search('#mediasportsmatchstatsbyplayer table.yom-data').last.search('tbody tr').each do |p|
      player_data = p.search('.athlete a').to_html
      next if player_data.blank?
      player = Player.find_or_create_by_yahoo_id(:yahoo_id => player_data.match(/[0-9]+/)[0],
                                                 :first_name => player_data.match(/>(.*) (.*)<\/a>/)[1],
                                                 :last_name => player_data.match(/>(.*) (.*)<\/a>/)[2],
                                                 :team_id => self.home.to_param)
      self.boxscores << Boxscore.create!(:player => player, :points => p.search('td').last.inner_html.to_i)
    end
    if response.search('#mediamodulematchheadergrandslam .teams-container .final').length > 0
      self.is_final = true
      home_points > away_points ? self.away.update_attributes!(:eliminated => true) : self.home.update_attributes!(:eliminated => true)
    end
  end
end
