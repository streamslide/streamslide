require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV['REDIS_URL'], :namespace => :streamslide }
end

Sidekiq.configure_server do |config|
  config.redis = { :url => ENV['REDIS_URL'], :namespace => :streamslide }
end

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == "root" && password == ENV['STREAMSLIDE_SIDEKIQ_ROOT_PASSWORD']
end
