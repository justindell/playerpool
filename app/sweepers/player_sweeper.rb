class PlayerSweeper < ActionController::Caching::Sweeper
  observe Player

  def after_create player
    expire_page :controller => 'players', :action => 'index', :format => 'json'
  end

  def after_update player
    expire_page :controller => 'players', :action => 'index', :format => 'json'
  end

  def after_destroy player
    expire_page :controller => 'players', :action => 'index', :format => 'json'
  end
end
