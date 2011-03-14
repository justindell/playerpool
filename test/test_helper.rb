ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha'

class ActiveSupport::TestCase
  fixtures :all
end

class Test::Unit::TestCase
  def setup
    response = mock
    response.stubs('body').returns(File.read(File.expand_path('../data/game.json', __FILE__)))
    Net::HTTP.stubs('get_response').returns(response) 
  end
end

