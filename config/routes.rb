Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'homes#index'
  post 'homes/load_generation', controller: 'homes', action: 'load_generation'
  post 'homes/next_generation', controller: 'homes', action: 'next_generation'
  post 'homes/reset_generation', controller: 'homes', action: 'reset'
end
