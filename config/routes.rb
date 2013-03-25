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
  match '/streamsessions/generate' => 'streamsessions#generate'
  post '/streamsessions/set_page' => 'streamsessions#set_page'
  get '/stream/:username/streamsessions/get_page' => 'streamsessions#get_page'

  post '/upload/status'
  get '/upload/job'

  put '/slide/edit' => 'slide#edit'

  # home
  root :to => "home#index"
  get '/browse' => 'home#browse', as: :browse

  # follow
  controller :follows do
    post '/follows/follow' => :follow, as: :create_follow
    post '/follows/unfollow' => :unfollow, as: :create_unfollow
    get '/follows/following/:id' => :following, as: :following
  end

  # note
  resources :notes, only: [:index, :create, :update, :destroy]

  #streaming
  get '/stream/:username/:sessionid' => 'streamsessions#index'
  get '/:username/:slug' => 'slide#index', :as => "slide_index"

  #faye message
  post '/fayemessages/publish'
end
