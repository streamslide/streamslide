class SlideController < ApplicationController

  def index
    begin
      @slide = Slide.find(params[:slide_id])
      @slide.increment! :view_count
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
    end
  end

end
