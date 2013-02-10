require 'test_helper'

class UserTeamsControllerTest < ActionController::TestCase
  setup do
    @user = User.create :email => 'foo@example.com', :password => 'test', :password_confirmation => 'test'
    @player = Player.create :yahoo_id => 1, :team => Team.create(:code => 'foo')
  end

  test "should post to create" do
    pusher = mock
    pusher.expects(:trigger).with('pick', anything).returns(true)
    Pusher.expects(:[]).with('draft').returns(pusher)
    post :create, :user_team => {:player_id => @player.id, :user_id => @user.id }
    assert_redirected_to edit_user_url(@user)
    assert_equal 'Player Added', flash[:notice]
    assert_equal 1, UserTeam.count
  end

  test "should destroy" do
    user_team = UserTeam.create :player_id => @player.id, :user_id => @user.id
    delete :destroy, :id => user_team.id
    assert_redirected_to edit_user_url(@user)
    assert_equal 'Player Removed', flash[:notice]
    assert_equal 0, UserTeam.count
  end
end
