class SlideController < ApplicationController

  def index
    begin
      @slide = Slide.find(params[:slide_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url
    end
  end

end
