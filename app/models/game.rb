require 'net/http'
require 'uri'

class Game < ActiveRecord::Base
  before_create :fetch_game_attributes
  validates_uniqueness_of :url
  belongs_to :home, :class_name => 'Team'
  belongs_to :away, :class_name => 'Team'
  has_many :boxscores, :dependent => :destroy

  def fetch_game_attributes
    http_response = Net::HTTP.get_response(URI.parse(self.url))
    http_response = Net::HTTP.get_response(URI.parse(http_response['location'])) if http_response.is_a? Net::HTTPRedirection 
    raise "ERROR: HTTP RESPONSE STATUS NOT 200: #{http_response.code} - #{http_response.body}" if http_response.code != '200'
    response = Nokogiri::HTML(http_response.body)
    away_team = response.search("#ysp-reg-box-header .hd h4 a").first.to_html
    home_team = response.search("#ysp-reg-box-header .hd h4 a").last.to_html
    self.away = Team.find_or_create_by_code(:code => away_team.match(/teams\/(.*)\"/)[1], :name => away_team.match(/\">(.*)<\/a>/)[1])
    self.home = Team.find_or_create_by_code(:code => home_team.match(/teams\/(.*)\"/)[1], :name => home_team.match(/\">(.*)<\/a>/)[1])
    home_points = response.css('#ysp-reg-box-line_score .home em').inner_html.to_i
    away_points = response.css('#ysp-reg-box-line_score .away em').inner_html.to_i
    response.css('#ysp-reg-box-game_details-game_stats').css('.bd').first.search('tbody tr').each do |p|
      player_data = p.search('a').to_html
      player = Player.find_or_create_by_yahoo_id(:yahoo_id => player_data.match(/[0-9]+/)[0],
                                                 :last_name => player_data.match(/>.* (.*)<\/a>/)[1],
                                                 :team_id => self.away.to_param)
      self.boxscores << Boxscore.create!(:player => player, :points => p.search('td').last.inner_html.to_i)
    end
    response.css('#ysp-reg-box-game_details-game_stats').css('.bd').last.search('tbody tr').each do |p|
      player_data = p.search('a').to_html
      player = Player.find_or_create_by_yahoo_id(:yahoo_id => player_data.match(/[0-9]+/)[0],
                                                 :last_name => player_data.match(/>.* (.*)<\/a>/)[1],
                                                 :team_id => self.home.to_param)
      self.boxscores << Boxscore.create!(:player => player, :points => p.search('td').last.inner_html.to_i)
    end
    self.away.update_attributes!(:eliminated => false)
    self.home.update_attributes!(:eliminated => false)
    if response.css('#ysp-reg-box-line_score .final').length > 0
      home_points > away_points ? self.away.update_attributes!(:eliminated => true) : self.home.update_attributes!(:eliminated => true)
    end
  end
end
