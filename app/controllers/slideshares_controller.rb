class SlidesharesController < ApplicationController
  before_filter :init_slideshare_api

  def index
    @slides = @slideshare.slideshows.find_all_by_user(current_user.slideshare_user_name) rescue []
  end
  
  def fetch

  end
 
  private
  def init_slideshare_api
    @slideshare = SlideShare::Base.new(
      api_key: ENV['SLIDESHARE_API_KEY'],
      shared_secret: ENV['SLIDESHARE_SECRET_KEY'])
  end
end
