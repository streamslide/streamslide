require 'test_helper'


describe PDFHandler do
  PDF_FIXTURE_FILES = "test/fixtures/test.pdf"
  let(:pdf) { PDFHandler.new(PDF_FIXTURE_FILES) }

  describe "using ghostscript" do
    it "count page" do
      assert_equal 4, pdf.page_count
    end

    it "convert pages to images" do
      images = pdf.convert_pages_to_images(1, 1)
      assert_equal 1, images.size
      images.each { |image| assert FileTest.exist?(image), "#{image} not exists" }
    end

    it "get size" do
      assert_equal [1000, 750], pdf.size
    end
  end
end
