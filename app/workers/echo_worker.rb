# This Worker is only for purpose of example to use sidekiq-status
# to store value back to job which are processing
#
# We dont use this job for our app
# TODO: delete it when finish implementing slide_worker
class EchoWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(message)
    10.times do |index|
      sleep 1
      store(result: index)
    end
  end
end
