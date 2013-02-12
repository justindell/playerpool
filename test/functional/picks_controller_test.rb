require 'test_helper'

class PicksControllerTest < ActionController::TestCase
  setup do
    @user = User.create :email => 'foo@example.com', :password => 'test', :password_confirmation => 'test'
    @player = Player.create :yahoo_id => 1, :team => Team.create(:code => 'foo')
  end

  test "should post to create" do
    pusher = mock
    pusher.expects(:trigger).with('pick', anything).returns(true)
    Pusher.expects(:[]).with('draft').returns(pusher)
    post :create, :pick => {:player_id => @player.id, :user_id => @user.id }
    assert_redirected_to edit_user_url(@user)
    assert_equal 'Player Added', flash[:notice]
    assert_equal 1, Pick.count
  end

  test "should destroy" do
    pick = Pick.create :player_id => @player.id, :user_id => @user.id
    delete :destroy, :id => pick.id
    assert_redirected_to edit_user_url(@user)
    assert_equal 'Player Removed', flash[:notice]
    assert_equal 0, Pick.count
  end
end
