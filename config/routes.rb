require 'sidekiq/web'

Launchvn::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  #match '/auth/:provider/callback' => 'authentications#create'
  devise_scope :user do
    get '/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  match '/new' => 'upload#index'
  post '/upload/status'
  get '/upload/job'

  root :to => "home#index"
end
