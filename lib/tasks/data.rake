require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'

namespace :data do
  desc "load all teams"
  task :load_teams => :environment do
    begin
      response = Net::HTTP.get_response(URI.parse("http://sports.yahoo.com/ncaa/basketball/teams"))
      doc = Nokogiri::HTML(response.body)
      doc.search("a").each do |line|
        if line.to_html.match(/ncaab\/teams\//)
          name = line.inner_html.gsub(/&#160;/, ' ').gsub(/&amp;/, '&').gsub(/&nbsp;/, ' ')
          puts "creating #{name}"
          Team.create :code => line.to_html.match(/ncaab\/teams\/(.*)\"/)[1], :name => name
        end
      end
    rescue => e
      puts "Caught exception finding all the teams: #{e}"
    end
  end

  desc "load all players"
  task :load_players => :environment do
    Team.all.each do |team|
      begin
        puts "loading #{team}"
        id_data = JSON.parse(open("https://sports.yahoo.com/site/api/resource/sports.alias;expected_entity=team;id=%2Fncaab%2Fteams%2F#{team.code}%2F").read)
        team_id = id_data["teamdefault_league"].keys.first
        data = JSON.parse(open("https://sports.yahoo.com/site/api/resource/sports.team.roster;id=#{team_id}").read)
        data['players'].each do |k, val|
          Player.create team_id: team.to_param, first_name: val['first_name'], last_name: val['last_name'], yahoo_id: val['player_id'].match(/\d+/)[0]
        end
      rescue => e
        puts "Caught exception finding all the players for #{team}: #{e}"
      end
    end
  end

  desc 'add yahoo id to teams'
  task :team_ids => :environment do
    Team.all.each do |team|
      begin
        puts "loading #{team}"
        id_data = JSON.parse(open("https://sports.yahoo.com/site/api/resource/sports.alias;expected_entity=team;id=%2Fncaab%2Fteams%2F#{team.code}%2F").read)
        team_id = id_data["teamdefault_league"].keys.first.match(/\d+/)[0]
        team.update_attributes! yahoo_id: team_id.to_i
      rescue => e
        puts "Caught exception finding id for #{team}: #{e}"
      end
    end
  end

  desc "refresh todays games"
  task :refresh => :environment do
    Refresher.refresh Date.today.to_s
  end
end
