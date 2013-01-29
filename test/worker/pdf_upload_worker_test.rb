require 'test_helper'

describe UploadWorker do
  let(:worker) { UploadWorker.new }

  it "down pdf file" do
    downloader = MiniTest::Mock.new
    downloader.expect :call, downloader, [nil]
    downloader.expect :store, nil, [/^\/tmp/]

    Downloader.stub(:new, downloader) do
      worker.verify_and_download_pdf_file
      downloader.verify
    end
  end

  it "convert pdf to images" do
    pdf = MiniTest::Mock.new
    pdf.expect :convert_pages_to_images, nil, [1, 20, { :output_width => nil }]

    worker.instance_variable_set(:@start_page, 1)
    worker.instance_variable_set(:@end_page, 20)
    worker.instance_variable_set(:@is_thumb, false)
    worker.instance_variable_set(:@pdf, pdf)
    worker.convert_pdf_to_images

    pdf.verify
  end

  describe "upload image to s3" do
    let(:job) { MiniTest::Mock.new }
    before do
      worker.instance_variable_set(:@start_page, 1)
      worker.instance_variable_set(:@end_page, 20)
      worker.instance_variable_set(:@is_thumb, false)
      worker.instance_variable_set(:@file_id, 'file_id')
    end

    it "run upload image file" do
      image_files = ['/tmp/test.jpg'] * 20
      worker.instance_variable_set(:@image_files, image_files)

      count = 0
      fussy = lambda do |image_file, key, &blk|
        count += 1
        image_file.must_equal '/tmp/test.jpg'
        EM.stop if count >= 20
      end

      Job.stub(:new, job) do
        worker.stub(:upload_image_file, fussy) do
          worker.upload_images_to_s3
          count.must_equal 20
        end
      end
    end
  end

end
