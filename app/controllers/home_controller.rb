class HomeController < ApplicationController
  before_filter :authenticate_user!, only: [:browse]

  def index
  end

  def browse
    @slides = Slide.joins('LEFT OUTER JOIN follows ON slides.user_id = follows.following_user_id').where('follows.user_id = ?', current_user.id).order('created_at DESC').limit(20)
  end

end
