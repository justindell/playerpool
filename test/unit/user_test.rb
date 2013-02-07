require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create :first_name => 'Joe', :last_name => 'Shmoe'
  end

  test 'should calculate total points' do
    deron = Player.create(:first_name => 'Deron', :last_name => 'Williams', :yahoo_id => 12345)
    deron.boxscores << Boxscore.create(:points => 20)
    @user.players << deron
    assert_equal 20, @user.total_points
    dee = Player.create(:first_name => 'Dee', :last_name => 'Brown', :yahoo_id => 11)
    dee.boxscores << Boxscore.create(:points => 15)
    @user.players << dee
    assert_equal 35, @user.total_points
  end

  test 'should calculate players remaining' do
    illinois = Team.create :code => 'ILLINOIS', :name => 'Illinois'
    @user.players << Player.create(:first_name => 'Deron', :last_name => 'Williams', :yahoo_id => 22, :team_id => illinois.to_param)
    hoosiers = Team.create :code => 'INDIANA', :name => 'Indiana', :eliminated => true
    @user.players << Player.create(:first_name => 'Marco', :last_name => 'Killingsworth', :yahoo_id => 33, :team_id => hoosiers.to_param)
    assert_equal 1, @user.players_remaining
  end
end
