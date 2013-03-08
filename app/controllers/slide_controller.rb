class SlideController < ApplicationController
  def index
    begin
      @user = User.find_by_username(params[:username])
      @slide = Slide.where(:user_id => @user.id, :slug => params[:slug]).first
      @slide.increment! :view_count
    rescue
      redirect_to root_url
    end
  end

  def edit
    @slide = Slide.find_by_s3_key(params[:slide][:s3_key])
    if @slide.update_attributes(params[:slide])
      @slide.send(:update_slug)
      redirect_to "/slide/#{@slide.id}"
    end
  end
end
