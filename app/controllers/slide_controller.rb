class SlideController < ApplicationController

  def index
    begin
      @slide = Slide.find(params[:slide_id])
      @slide.increment! :view_count
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
    end
  end

  def edit
    @slide = Slide.find_by_s3_key(params[:slide][:s3_key])
    if @slide.update_attributes(params[:slide])
      redirect_to "/slide/#{@slide.id}"
    end
  end
end
