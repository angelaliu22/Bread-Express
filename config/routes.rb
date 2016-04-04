BreadExpress::Application.routes.draw do

    # Routes for main resources
    resources :addresses
    resources :customers
    resources :orders
    resources :sessions
    resources :users
    resources :items
    resources :item_prices


    # Authentication routes
    get 'user/edit' => 'users#edit', as: :edit_current_user
    get 'signup' => 'customers#new', as: :signup
    get 'logout' => 'sessions#destroy', as: :logout
    get 'login' => 'sessions#new', as: :login


    # Semi-static page routes
    get 'home' => 'home#home', as: :home
    get 'about' => 'home#about', as: :about
    get 'contact' => 'home#contact', as: :contact
    get 'privacy' => 'home#privacy', as: :privacy
    get 'search' => 'home#search', as: :search
    get 'cylon' => 'errors#cylon', as: :cylon
  
  # Set the root url
  root :to => 'home#home'  
  
  # Named routes
    get 'add_item/:id' => 'orders#add_item', as: :add_item
    get 'remove_item/:id' => 'orders#remove_item', as: :remove_item
    get 'view_cart' => 'orders#view_cart', as: :view_cart
    get 'checkout_cart' => 'orders#checkout_cart', as: :checkout_cart
    
    get 'items_to_bake' => 'home#items_to_bake', as: :items_to_bake
    get 'orders_to_ship' => 'home#orders_to_ship', as: :orders_to_ship
    get 'order_has_been_shipped/:id' => 'home#order_has_been_shipped', as: :order_has_been_shipped


  
  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
