Playerpool::Application.routes.draw do
  devise_for :users

  resources :teams, :players
  resources :games, :except => :destroy
  resources :users, :except => [:new, :create, :update, :destroy]
  resources :picks, :only => [:create, :destroy]
  resources :draft, :only => :index
  resources :messages, :only => :create
  
  match "refresh" => "player_pool#refresh"
  root :to => "player_pool#index"
end
