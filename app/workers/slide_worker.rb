require 'net/http'

class SlideWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(url)
    downloader = Downloader.new url
    downloader.store
    puts downloader.filepath
  end
end
