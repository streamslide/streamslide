class UploadController < ApplicationController
  include UUID

  prepend_before_filter :current_user, :only => :exhibit
  before_filter :authenticate_user!

  def index
    @current_user = current_user
    @slide = Slide.new
    @slide.s3_key = uuid
  end

  def status
    url_path = params[:url]
    job_id = SlideWorker.perform_async(current_user.id, url_path)

    render :json => { :job_id => job_id }
  end

  def job
    job = Job.new params[:job_id]
    ret = job.get_fields :total_page, :processed_page, :slide_id

    ret[:total_page] ||= 0
    ret[:processed_page] ||= 0

    has_page = ret[:total_page].to_i > 0
    finish_processing = ret[:processed_page].to_i >= ret[:total_page].to_i * 2

    if has_page and finish_processing then
      ret[:status] = "complete"
    else
      ret[:status] = "processing"
    end

    render :json => ret.to_json
  end
end
