require 'sidekiq/web'

Launchvn::Application.routes.draw do
  devise_for :users
  match '/auth/:provider/callback' => 'authentications#create'
  match '/new' => 'upload#index'
  root :to => "home#index"

  mount Sidekiq::Web, at: '/sidekiq'
end
