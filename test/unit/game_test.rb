require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'should fill in attributes' do
    game = Game.create! :url => 'http://sports.yahoo.com'
    assert_not_nil game
    assert_equal 'oae', game.away.code
    assert_equal 'kaa', game.home.code
  end

  test 'should add points to player' do
    game = Game.create! :url => 'http://sports.yahoo.com'
    assert_equal 3, Player.find_by_last_name('Neal').points
    assert_equal 19, Player.find_by_last_name('Tharpe').points
  end

  test 'should eliminate losers' do
    game = Game.create! :url => 'http://sports.yahoo.com'
    team = Team.find_by_code('oae')
    player = Player.find_by_last_name('Booker')
    assert team.eliminated?, 'Oklahoma was not eliminated'
    assert player.eliminated?, 'Booker was not eliminated'
  end

  test 'should subtract points when deleting game' do
    game = Game.create! :url => 'http://sports.yahoo.com'
    game.destroy
    assert_equal 0, Player.find_by_last_name('Neal').points
    assert_equal 0, Player.find_by_last_name('Tharpe').points
  end
end
