require 'securerandom'

class Slide < ActiveRecord::Base
  belongs_to :user
  attr_accessible :filename, :pages, :s3_key, :user_id, :name, :description

  def author
    @author ||= user
  end

  def page_url index
    "#{s3_prefix_url}/slide/#{s3_key}/slide_#{index}.jpg"
  end

  def thumbnail_url index
    "#{s3_prefix_url}/slide/#{s3_key}/thumb_#{index}.jpg"
  end

  def pdf_url
    "#{s3_prefix_url}/slide/#{s3_key}/#{filename}"
  end

  def s3_upload_key
    "slide/#{s3_key}/$filename}"
  end

  private

  def s3_prefix_url
    "https://s3.amazonaws.com/#{ENV["AWS_S3_BUCKET_NAME"]}"
  end
end
