require 'sidekiq/web'

Launchvn::Application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  devise_scope :user do
    get '/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks",
    :registrations => "users/registrations"
  }
  resources :users, only: [:show]

  match '/new' => 'upload#index'
  post '/upload/status'
  get '/upload/job'

  put '/slide/edit' => 'slide#edit'
  get '/:username/:slug' => 'slide#index', :as => "slide_index"

  root :to => "home#index"
end
