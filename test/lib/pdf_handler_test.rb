require 'test_helper'


describe PDFHandler do
  PDF_FIXTURE_FILES = "test/fixtures/test.pdf"
  let(:pdf) { PDFHandler.new(PDF_FIXTURE_FILES) }

  describe "using ghostscript" do
    it "count page" do
      assert_equal 4, pdf.page_count
    end

    it "convert pages to images" do
      images = pdf.convert_pages_to_images(1, 4)
      images.each { |image| assert FileTest.exist?(image), "#{image} not exists" }
    end
  end
end
