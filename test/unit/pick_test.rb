require 'test_helper'

class PickTest < ActiveSupport::TestCase
  test 'should not pick out of order' do
    one = User.create! draft_position: 1, :email => 'foo@example.com', :password => 'test', :password_confirmation => 'test' 
    two = User.create! draft_position: 2, :email => 'bar@example.com', :password => 'test', :password_confirmation => 'test' 
    players = [Player.create(yahoo_id: 1), Player.create(yahoo_id: 2), Player.create(yahoo_id: 3)]

    # round 1 turn 1
    pick = Pick.new player: players[0], user: two
    assert !pick.valid?, 'player two cannot pick first in round one turn one'
    pick = Pick.new player: players[0], user: one
    assert pick.valid?, 'player one should pick first in round one turn one'
    pick.save

    # round 1 turn 2
    pick = Pick.new player: players[1], user: one
    assert !pick.valid?, 'player one cannot pick first in round one turn two'
    pick = Pick.new player: players[1], user: two
    assert pick.valid?, 'player two should pick first in round one turn two'
    pick.save

    # round 2 turn 1
    pick = Pick.new player: players[2], user: one
    assert !pick.valid?, 'player one cannot pick first in round two turn one'
    pick = Pick.new player: players[2], user: two
    assert pick.valid?, 'player two should pick first in round two turn one'
  end
end
