require 'securerandom'
require 'shellwords'

# Apart of this source code is borrow from grim gems
# `https://github.com/jonmagic/grim`
#
# `grim` generate image for each page of pdf separately - which
# I think is slow and cost time. So I rewrite it by myself
class PDFHandler

  # eliminate \n from output of shell command
  WarningRegex = /\*\*\*\*.*\n/

  def initialize(filepath)
    @filepath = filepath
  end

  def page_count
    @page_count ||= get_page_count
  end

  def convert_pages_to_images(min_page, max_page, options = {})
    default_pattern = "/tmp/image-#{SecureRandom.hex(12)}-%d.jpg"
    output_pattern = options[:output_pattern] ||  default_pattern
    quality = options[:quality] || '100'
    command = ["gs", "-dSAFER", "-dBATCH", "-dNOPAUSE", "-sDEVICE=jpeg",
      "-dFirstPage=#{min_page}", "-dLastPage=#{max_page}",
      "-dTextAlphaBits=4", "-dGraphicsAlphaBits=4",
      "-r#{quality}", "-sOutputFile=#{output_pattern}", "-q",
      Shellwords.shellescape(@filepath), "-c", "quit"]
    `#{command.join(' ')}`
    (1..max_page-min_page).to_a.map { |index| output_pattern % index }
  end

  private

  def get_page_count
    command = ["gs", "-dNODISPLAY", "-q",
      "-sFile=#{Shellwords.shellescape(@filepath)}",
      File.expand_path('../../lib/pdf_info.ps', __FILE__)]
    result = `#{command.join(' ')}`
    result.gsub(WarningRegex, '').to_i
  end
end
