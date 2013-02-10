require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  test "should create chat message" do
    assert_difference('Message.count') do
      pusher = mock
      pusher.expects(:trigger).with('chat', anything).returns(true)
      Pusher.expects(:[]).with('draft').returns(pusher)
      post :create, :message => 'Hi world'
    end
  end
end
