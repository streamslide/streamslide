class Job
  include Sidekiq::Status::Storage

  def initialize(job_id)
    @id = job_id
  end

  def get_fields(*fields)
    ret = Sidekiq.redis do |conn|
      conn.hmget @id, *fields
    end
    Hash[*fields.zip(ret).flatten]
  end

  def store(status_update)
    store_for_id(@id, status_update)
  end

  def incr(field, value = 1)
    Sidekiq.redis do |conn|
      conn.hincrby @id, field, value
    end
  end
end
