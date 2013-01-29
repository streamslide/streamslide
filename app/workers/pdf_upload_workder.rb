require 'eventmachine'
require 'em-http-request'

class UploadWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  include UUID

  def config_redis_for_sidekiq
    Sidekiq.configure_server do |config|
      config.redis = {
        :url => ENV['REDIS_URL'],
        :namespace => :streamslide,
        :size => 1
      }
    end
  end

  def size
    @size ||= is_thumb ? 210 : 1024
  end

  def image_type_name
    @image_type_name ||= @is_thumb ? "thumb": "slide"
  end

  def verify_and_download_pdf_file
    pdf_file_path = "/tmp/#{@file_id}.pdf"

    # generate new files, because may be there are other jobs
    # are downloading and saving to same location
    unless FileTest.exists?(pdf_file_path) then
      pdf_file_path = "/tmp/#{uuid}.pdf"
      downloader = Downloader.new url
      downloader.store pdf_file_path
    end

    @pdf = PDFHandler.new pdf_file_path
  end

  def convert_pdf_to_images
    @image_files =  @pdf.convert_pages_to_images(@start_page,
                                                 @end_page,
                                                 output_width: @size)
  end

  def upload_image_file image_file, key, &block
    on_error = Proc.new do |http|
      puts "An error occured: #{http.response_header.status}"
    end

    item = Happening::S3::Item.new(
        ENV['AWS_S3_BUCKET_NAME'], key,
        :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
        :permissions => 'public-read')

    item.put(File.read(image_file),
             :on_error => on_error,
             :on_success => block,
             :headers => { "Content-Type" => "image/jpeg" })
  end

  def upload_images_to_s3
    EM.run do
      total_page = @end_page - @start_page + 1
      pending = total_page

      job = Job.new @job_id

      total_page.times do |index|
        slide_index = @start_page + index
        key = "slide/#{@file_id}/#{image_type_name}_#{slide_index}.jpg"

        upload_image_file(@image_files[index], key) do
          job.incr :processed_page
          puts "upload file to #{key}"

          # update event machine state
          pending -= 1
          EM.stop if pending <= 0
        end
      end
    end
  end

  def perform(job_id, url, file_id, start_page, end_page, is_thumb)
    Process.fork do
      config_redis_for_sidekiq

      @url = url
      @file_id = file_id
      @start_page = start_page
      @end_page = end_page
      @is_thumb = is_thumb
      @job_id = job_id

      verify_and_download_pdf_file
      convert_pdf_to_images
      upload_images_to_s3
    end
  end

end
