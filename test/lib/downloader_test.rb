require 'test_helper'

describe Downloader do

  FIXTURE_FILE = 'test/fixtures/image1.jpg'
  TEST_URL = 'distilleryimage2.s3.amazonaws.com/02443a5850b111e29d0322000a1f97e3_7.jpg'

  include FileComparator

  describe "download" do
    it "test download file with http" do
      skip "test download cost time"
      downloader = Downloader.new "http://#{TEST_URL}"
      downloader.store
      assert_file_equal FIXTURE_FILE, downloader.filepath
    end

    it "test file with https" do
      skip "test download cost time"
      downloader = Downloader.new "https://#{TEST_URL}"
      downloader.store
      assert_file_equal FIXTURE_FILE, downloader.filepath
    end
  end

  describe "extension" do
    it "test file extension" do
      downloader = Downloader.new "http://example.com/abc.def.xyz.mmm"
      assert_equal ".mmm", downloader.file_extension
    end

    it "test file extension null" do
      downloader = Downloader.new "http://abcdefxyzmmm.com/abc"
      assert_equal "", downloader.file_extension
    end

    it "test file extension with param" do
      downloader = Downloader.new "http://abc.com/def.xyz.mmm?x=a&y=b&z=c"
      assert_equal ".mmm", downloader.file_extension
    end
  end
end
