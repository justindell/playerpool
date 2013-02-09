require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  test "should create message" do
    assert_difference('Message.count') do
      pusher = mock
      pusher.expects(:trigger).returns(true)
      Pusher.expects(:[]).with('draft').returns(pusher)
      post :create, :message => { :body => 'Hi world' }
    end
  end
end
