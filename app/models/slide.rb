require 'securerandom'

class Slide < ActiveRecord::Base
  belongs_to :user
  attr_accessible :filename, :pages, :s3_key, :user_id,
                  :name, :description, :view_count, :slug

  def author
    @author ||= user
  end

  def slide_url_prefix
    "#{s3_prefix_url}/slide/#{s3_key}"
  end

  def page_url index
    "#{slide_url_prefix}/slide_#{index}.jpg"
  end

  def thumbnail_url index
    "#{slide_url_prefix}/thumb_#{index}.jpg"
  end

  def pdf_url
    "#{slide_url_prefix}/#{filename}"
  end

  def s3_upload_key
    "slide/#{s3_key}/$filename}"
  end

  private

  def s3_prefix_url
    "https://s3.amazonaws.com/#{ENV["AWS_S3_BUCKET_NAME"]}"
  end

  def update_slug
    slug = name.downcase.gsub(/ /, '-')
    if Slide.where(:slug => slug).count > 0 then
      slug = "#{slug}-#{Time.now.to_i}"
    end
    update_attributes(:slug => slug)
  end
end
