require 'eventmachine'
require 'em-http-request'

class UploadWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include UUID

  def get_pdf(url, file_id)
    pdf_file_path = "/tmp/#{file_id}.pdf"

    # generate new files, because may be there are other jobs
    # are downloading and saving to same location
    unless FileTest.exists?(pdf_file_path) then
      pdf_file_path = "/tmp/#{uuid}.pdf"
      downloader = Downloader.new url
      downloader.store pdf_file_path
    end

    PDFHandler.new pdf_file_path
  end

  def perform(job_id, url, file_id, start_page, end_page, is_thumb)
    job = Job.new job_id

    pdf = get_pdf url, file_id
    size = is_thumb ? 210 : 1024

    # convert pdf pages to images
    image_files = pdf.convert_pages_to_images start_page, end_page, output_width: size

    EM.run do
      total_page = end_page - start_page + 1
      pending = total_page

      total_page.times do |index|
        slide_index = start_page + index
        key = "slide/#{file_id}/#{is_thumb ? "thumb" : "slide"}_#{slide_index}.jpg"

        on_error = Proc.new do |http|
          puts "An error occured: #{http.response_header.status}"
        end

        item = Happening::S3::Item.new(
            ENV['AWS_S3_BUCKET_NAME'], key,
            :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
            :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
            :permissions => 'public-read')
        item.put(File.read(image_files[index]), :on_error => on_error,
            :headers => { "Content-Type" => "image/jpeg" }) do |response|

          # update job
          job.incr :processed_page
          puts "upload file #{image_files[index]} by #{is_thumb}"

          pending -= 1
          EM.stop if pending <= 0
        end
      end
    end
  end

end
