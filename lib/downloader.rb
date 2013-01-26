require 'net/http'

# Download file with simple, easy, independent and memory care way
# Usage
#   > downloader = Downloader.new 'http://s3.amazoneaws.com/bucket/test.pdf'
#   > downloader.store
#
class Downloader
  def initialize(url, filepath = nil)
    @uri = URI(url)
  end

  def file_extension
    path = @uri.path
    index = path.rindex('.')
    unless index.nil? then path[index..-1] else '' end
  end

  def filepath
    if @filepath.nil? then
      @filepath = nil
    end
    @filepath
  end

  def store(path = nil)
    @filepath = get_path path
    Net::HTTP.start(@uri.host, @uri.port, :use_ssl => @uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new @uri.request_uri

      http.request request do |response|
        open filepath, 'wb' do |io|
          response.read_body do |chunk|
            io.write chunk
          end
        end
      end
    end
  end

  private

  def get_path(value = nil)
    if value.nil? then "/tmp/#{SecureRandom.hex(12)}#{file_extension}" else value end
  end
end
