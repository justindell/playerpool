require 'net/http'
require 'uri'

class PlayerPoolController < ApplicationController
  def index
    @users = User.includes(:players => [:boxscores, :team]).sort_by{|u| u.total_points}.reverse
  end

  def refresh
    raise "must specify a date (YYYY-MM-DD)" unless params[:date]
    Rails.logger.info "fetching response from http://rivals.yahoo.com/ncaa/basketball/scoreboard?d=#{params[:date]}"
    http_response = Net::HTTP.get_response(URI.parse("http://rivals.yahoo.com/ncaa/basketball/scoreboard?d=#{params[:date]}"))
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
    @users = User.includes(:players => [:boxscores, :team]).sort_by{|u| u.total_points}.reverse
    render :partial => 'standings'
  end
end
