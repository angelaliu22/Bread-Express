BreadExpress::Application.routes.draw do

    # Routes for main resources
    resources :addresses
    resources :customers
    resources :orders
    resources :sessions
    resources :users
    resources :items


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
    get 'cart' => 'orders#cart', as: :cart
    get 'checkout_cart' => 'orders#checkout_cart', as: :checkout_cart
    get 'place_order' => 'orders#place_order', as: :place_order


  
  # Last route in routes.rb that essentially handles routing errors
  get '*a', to: 'errors#routing'
end
