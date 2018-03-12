require 'net/http'
require 'uri'

BASE_URL = 'https://api-secure.sports.yahoo.com/v1/editorial/s/'
YAHOO_URL = BASE_URL + 'scoreboard?leagues=ncaab&date='

class Refresher
  def self.refresh date
    Rails.logger.info "fetching response from #{YAHOO_URL}#{date}"
    data = JSON.parse(open("#{YAHOO_URL}#{date}").read)
    data['service']['scoreboard']['games'].each do |_, data|
      full_url = BASE_URL + "boxscore/#{data['gameid']}"
      game = Game.find_by_url full_url
      game.destroy if game && !game.is_final
      Game.create(url: full_url) if game.nil? || game.destroyed?
    end
  end
end
