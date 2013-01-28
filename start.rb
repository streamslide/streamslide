class HerokuForkingWorker
  def initialize &block
    @block = block
  end

  def run
    Process.fork do
      @block.call
    end
  end

end

class HerokuSupervise
  def initialize
    @workers = []
  end

  def add_worker worker
    @workers << worker
  end

  def run
    children = @workers.inject({}) { |h, worker| h[worker.run] = worker; h }
    loop do
      pid = Process.wait
      worker = children.delete pid
      children[worker.run] = worker
    end
  end
end

web = HerokuForkingWorker.new do
  `bundle exec unicorn -p $PORT -c ./config/unicorn.rb`
end

worker = HerokuForkingWorker.new do
  `bundle exec sidekiq -C config/sidekiq.yml`
end

supervise = HerokuSupervise.new
supervise.add_worker worker
supervise.run
