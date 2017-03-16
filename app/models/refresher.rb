require 'net/http'
require 'uri'

YAHOO_URL = 'http://sports.yahoo.com'

class Refresher
  def self.refresh date
    Rails.logger.info "fetching response from #{YAHOO_URL}/college-basketball/scoreboard/?dateRange=#{date}"
    http_response = Net::HTTP.get_response(URI.parse("#{YAHOO_URL}/college-basketball/scoreboard/?dateRange=#{date}"))
    raise "ERROR: HTTP RESPONSE STATUS NOT 200: #{http_response.body}" if http_response.code != '200'
    doc = Nokogiri::HTML(http_response.body)
    doc.search('#scoreboard-group-2 li a').each do |game|
      #next if game.attr('class').match(/pre/)
      url = YAHOO_URL + game.attr('href')
      game = Game.find_by_url url
      game.destroy if game && !game.is_final
      Game.create(:url => url) if game.nil? || game.destroyed?
    end
  end
end
