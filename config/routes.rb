Playerpool::Application.routes.draw do
  devise_for :users

  resources :teams, :players
  resources :games, :except => :destroy
  resources :users, :except => [:new, :create, :update, :destroy] do
    post :add_player, :on => :member
  end
  
  match "refresh" => "player_pool#refresh"
  root :to => "player_pool#index"
end
