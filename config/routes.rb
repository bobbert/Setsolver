ActionController::Routing::Routes.draw do |map|

  # nested resources for /players/1 and /players/1/games/1
  map.resources :players  do |players|  
    players.resources :games
  end

  # game playing link: /games/1/players/1/play
  map.play 'players/:player_id/games/:id/play', :controller => 'games', :action => 'play'

  # game playing link: /games/1/players/1/play
  map.archive 'players/:player_id/games/:id/archive', :controller => 'games', :action => 'archive'

  # add player to game: /games/1/players/1/add_player
  map.add_player 'players/:player_id/games/:id/add_player', :controller => 'games', :action => 'add_player'

  # remove player from game: /games/1/players/1/remove_player
  map.remove_player 'players/:player_id/games/:id/remove_player', :controller => 'games', :action => 'remove_player'

  # setgame information link: /games/1/players/1/setgame
  map.setgame 'players/:player_id/games/:id/setgame.:format', :controller => 'games', :action => 'setgame'

  # Ajax updater link: /games/1/players/1/refresh
  map.refresh 'players/:player_id/games/:id/refresh.:format', :controller => 'games', :action => 'refresh'


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
#  map.connect ':controller/:id/:action'
#  map.connect ':controller/:id/:action.:format'
end
