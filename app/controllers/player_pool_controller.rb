require 'net/http'
require 'uri'

class PlayerPoolController < ApplicationController
  def index
    @users = User.all.sort_by{|u| u.total_points}.reverse
  end

  def refresh
    raise "must specify a date (YYYY-MM-DD)" unless params[:date]
    puts "fetching response from http://rivals.yahoo.com/ncaa/basketball/scoreboard?d=#{params[:date]}"
    http_response = Net::HTTP.get_response(URI.parse("http://rivals.yahoo.com/ncaa/basketball/scoreboard?d=#{params[:date]}"))
    raise "ERROR: HTTP RESPONSE STATUS NOT 200: #{http_response.body}" if http_response.code != '200'
    doc = Nokogiri::HTML(http_response.body)
    doc.search('#ysp-leaguescoreboard table.ysptblclbg3').each do |game|
      link = game.search('table').last.search('.yspscores').last.search('a').first['href']
      Game.destroy_all(:url => "http://rivals.yahoo.com/#{link}")
      Game.create :url => "http://rivals.yahoo.com/#{link}"
    end
    redirect_to root_url
  end
end
