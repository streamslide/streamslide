require 'sidekiq/web'

Launchvn::Application.routes.draw do
  devise_for :users
  mount Sidekiq::Web, at: '/sidekiq'

  match '/auth/:provider/callback' => 'authentications#create'

  match '/new' => 'upload#index'
  post '/upload/status'
  get '/upload/job'

  root :to => "home#index"
end
