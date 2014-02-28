require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = User.create :first_name => 'Joe', :last_name => 'Schmoe', :email => 'foo@example.com', :password => 'test', :password_confirmation => 'test'
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user.to_param
    assert_response :success
  end
end
