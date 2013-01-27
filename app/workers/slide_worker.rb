class SlideWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def get_upload_id(url)
    normal_url = url.gsub(/%2F/, '/')
    a = normal_url[49..-1]
    a[0..a.rindex('/') - 1]
  end

  def perform(url)
    downloader = Downloader.new url
    file_id = get_upload_id url
    downloader.store "/tmp/#{file_id}.pdf"

    pdf = PDFHandler.new downloader.filepath
    store :total_page => pdf.page_count, :processed_page => 0

    UploadWorker.perform_async(@id, url, file_id, 1, pdf.page_count, false)
    UploadWorker.perform_async(@id, url, file_id, 1, pdf.page_count, true)
  end
end
