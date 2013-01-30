ENV['RACK_ENV'] = ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require 'minitest/unit'
require 'minitest/spec'
require 'minitest/mock'
require 'sidekiq/testing'
require 'stub_instance'
require 'digest'
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all
end

module FileComparator
  def assert_file_equal(file1, file2)
    assert checksum(file1) == checksum(file2), "#{file1} not equals #{file2}"
  end

  private

  def checksum(file)
    Digest::SHA2.hexdigest(File.read(file))
  end
end
