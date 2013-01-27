require 'securerandom'
require 'shellwords'

# Apart of this source code is borrow from grim gems
# `https://github.com/jonmagic/grim`
#
# `grim` generate image for each page of pdf separately - which
# I think is slow and cost time. So I rewrite it by myself
class PDFHandler

  include UUID

  # eliminate \n from output of shell command
  WarningRegex = /\*\*\*\*.*\n/

  def initialize(filepath)
    @filepath = filepath
  end

  def page_count
    @page_count ||= get_page_count
  end

  def size
    @size ||= get_size
  end

  def convert_pages_to_images(min_page, max_page, options = {})
    default_pattern = "/tmp/image-#{uuid}-%d.jpg"

    pattern = options[:output_pattern] ||  default_pattern
    width = options[:output_width] || 1024
    height = width * size[1] / size[0]
    quality = options[:quality] || '100'

    command = ["gs", "-dSAFER", "-dBATCH", "-dNOPAUSE", "-sDEVICE=jpeg",
        "-dFirstPage=#{min_page}", "-dLastPage=#{max_page}",
        "-dTextAlphaBits=4", "-dGraphicsAlphaBits=4", # antialias
        "-dPDFFitPage", # calculate size of ouput image
        "-g#{width}x#{height}",
        "-r#{quality}",
        "-sOutputFile=#{pattern}", "-q",
        Shellwords.shellescape(@filepath), "-c", "quit"]

    `#{command.join(' ')}`
    (1..max_page-min_page + 1).to_a.map { |index| pattern % index }
  end

  private

  def get_page_count
    command = ["gs", "-dNODISPLAY", "-q",
        "-sFile=#{Shellwords.shellescape(@filepath)}",
        File.expand_path('../../lib/pdf_info.ps', __FILE__)]

    result = `#{command.join(' ')}`
    result.gsub(WarningRegex, '').to_i
  end

  def get_size
    # generate png image
    filepath = "/tmp/#{SecureRandom.hex(12)}.png"
    command = ["gs", "-dSAFER", "-dBATCH", "-dNOPAUSE", "-sDEVICE=pnggray",
        "-dFirstPage=1", "-dLastPage=1",
        "-r100x100", "-sOutputFile=#{filepath}", "-q",
        Shellwords.shellescape(@filepath), "-c", "quit"]
    `#{command.join(' ')}`

    # calculate size of png image
    IO.read(filepath)[0x10..0x18].unpack('NN')
  end
end
