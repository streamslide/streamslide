require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-status'

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV['REDIS_URL'], :namespace => :streamslide }
end

Sidekiq.configure_server do |config|
  config.redis = { :url => ENV['REDIS_URL'], :namespace => :streamslide }
end

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == "root" && password == ENV['STREAMSLIDE_SIDEKIQ_ROOT_PASSWORD']
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Status::ClientMiddleware
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Status::ServerMiddleware
  end
end
