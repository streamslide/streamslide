class UploadController < ApplicationController
  prepend_before_filter :current_user, :only => :exhibit
  before_filter :authenticate_user!

  def index
    @current_user = current_user
  end

  def status
    url_path = params[:url]
    job_id = SlideWorker.perform_async(url_path)

    render :json => { :job_id => job_id }
  end

  def job
    job_id = params[:job_id]
    result = Sidekiq::Status.send :read_field_for_id, job_id, :result

    respond_to do |format|
      format.json { render :json => { :result => result } }
    end
  end
end
