ActionController::Routing::Routes.draw do |map|

  map.root :controller => "games", :action => "index"

  # mapping games resources, in standard RESTful format
  map.resources :games

  # game playing link: /games/1/play
  map.play 'games/:id/play', :controller => 'games', :action => 'play'

  # game archive link for finished games: /games/1/archive
  map.archive 'games/:id/archive', :controller => 'games', :action => 'archive'

  # Ajax updater link: /games/1/refresh
  map.refresh 'games/:id/refresh.:format', :controller => 'games', :action => 'refresh'

  # setgame information link: /games/1/setgame
  map.setgame 'games/:id/setgame.:format', :controller => 'games', :action => 'setgame'

  # add player to game: /games/1/add_player  (uncomment when multiplayer is added)
#  map.add_player 'games/:id/add_player', :controller => 'games', :action => 'add_player'

  # remove player from game: /games/1/remove_player  (uncomment when multiplayer is added)
#  map.remove_player 'games/:id/remove_player', :controller => 'games', :action => 'remove_player'

  # RWP TEST: XFBML test link: /games/1/test
#  map.test 'games/:id/test.:format', :controller => 'games', :action => 'test'


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
