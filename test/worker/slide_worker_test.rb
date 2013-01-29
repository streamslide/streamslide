require 'test_helper'

describe SlideWorker do

  let(:worker) { SlideWorker.new }

  describe "when give an url" do
    it "get file id with custom url" do
      url = 'http://s3.amazonaws.com/bucket/name/file_id/file_name'
      worker.instance_variable_set(:@url, url)
      worker.file_id.must_equal 'file_id'
    end

    it "get file id with fix url" do
      url = 'https://s3.amazonaws.com/skunkworks-test/uploads/file_id/file_name.pdf'
      worker.instance_variable_set(:@url, url)
      worker.file_id.must_equal 'file_id'
    end
  end

  describe "when perform with an url" do
    it "store pdf file" do
      url = "http://s3.amazonaws.com/test/file_id/filename"
      worker.instance_variable_set(:@url, url)

      downloader = MiniTest::Mock.new
      downloader.expect(:store, nil, ['/tmp/file_id.pdf'])
      worker.instance_variable_set(:@downloader, downloader)

      worker.store_pdf_file
      downloader.verify
    end

    it "dispatch job" do
      pdf = PDFHandler.new nil
      pdf.instance_variable_set(:@page_count, 16)
      worker.instance_variable_set(:@file_id, 'file_id')
      worker.instance_variable_set(:@pdf, pdf)

      worker.dispatch_job_to_uploader
      assert_equal 4, UploadWorker.jobs.size
    end

    it "dispatch job with small number of image" do
      pdf = PDFHandler.new nil
      pdf.instance_variable_set(:@page_count, 4)
      worker.instance_variable_set(:@file_id, 'file_id')
      worker.instance_variable_set(:@pdf, pdf)

      fussy = lambda do |id, url, file_id, start_page, end_page, is_thumb|
        file_id.must_equal 'file_id'
        start_page.must_equal 1
        end_page.must_equal 4
      end

      UploadWorker.stub(:perform_async, fussy) do
        worker.dispatch_job_to_uploader
      end
    end
  end

end
