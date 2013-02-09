ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/setup'

class Test::Unit::TestCase
  def setup
    response = mock
    response.stubs('body').returns(File.read(File.expand_path('../data/game.html', __FILE__)))
    response.stubs('code').returns('200')
    Net::HTTP.stubs('get_response').returns(response) 
  end
end

class ActionController::TestCase
  include Devise::TestHelpers

  setup do
    sign_in User.create(:email => 'email@email.com', :password => 'password', :password_confirmation => 'password')
  end

  def current_user
    @controller.current_user
  end
end
