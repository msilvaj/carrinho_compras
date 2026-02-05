require 'sidekiq/web'

Rails.application.routes.draw do
  # Mount Sidekiq Web UI (optional, for monitoring)
  mount Sidekiq::Web => '/sidekiq'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Cart API endpoints
  get "/cart", to: "carts#show"
  post "/cart", to: "carts#create"
  post "/cart/add_item", to: "carts#add_item"
  delete "/cart/:product_id", to: "carts#destroy_item"

  # Defines the root path route ("/")
  root "home#index"
end
