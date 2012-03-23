require 'net/http'
require 'uri'

class Refresher
  def self.refresh date
    Rails.logger.info "fetching response from http://rivals.yahoo.com/ncaa/basketball/scoreboard?d=#{date}"
    http_response = Net::HTTP.get_response(URI.parse("http://rivals.yahoo.com/ncaa/basketball/scoreboard?d=#{date}"))
    raise "ERROR: HTTP RESPONSE STATUS NOT 200: #{http_response.body}" if http_response.code != '200'
    doc = Nokogiri::HTML(http_response.body)
    doc.search('#ysp-leaguescoreboard table.ysptblclbg3').each do |game|
      link = game.search('table').last.search('.yspscores').last.search('a').first
      next unless link.inner_html == "Box Score"
      url = "http://rivals.yahoo.com/#{link['href']}"
      game = Game.find_by_url url
      game.destroy if game && !game.is_final
      Game.create(:url => url) if game.nil? || game.destroyed?
    end
  end
end
