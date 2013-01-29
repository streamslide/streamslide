class SlideWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  @@images_per_job = 15

  def file_id
    unless @file_id then
      normalize_url = @url.gsub(/%2F/, '/')
      url_without_filename = normalize_url[0..normalize_url.rindex('/') - 1]
      @file_id = url_without_filename[url_without_filename.rindex('/') + 1..-1]
    end
    @file_id
  end

  def downloader
    @downloader ||= Downloader.new @url
  end

  def store_pdf_file
    downloader.store "/tmp/#{file_id}.pdf"
  end

  def pdf
    @pdf ||= PDFHandler.new downloader.filepath
  end

  def update_job_in_redis
    store :total_page => pdf.page_count, :processed_page => 0
  end

  def dispatch_job_to_uploader
    number_of_jobs = (pdf.page_count - 1)/ @@images_per_job + 1

    number_of_jobs.times do |index|
      start_page = index * @@images_per_job + 1
      end_page = start_page + @@images_per_job - 1
      end_page = pdf.page_count if end_page > pdf.page_count

      UploadWorker.perform_async(@id, @url, file_id, start_page, end_page, false)
      UploadWorker.perform_async(@id, @url, file_id, start_page, end_page, true)
    end
  end

  def perform(url)
    @url = url
    store_pdf_file
    dispatch_job_to_uploader
    update_job_in_redis
  end

end
