class UploadController < ApplicationController
  prepend_before_filter :current_user, :only => :exhibit
  before_filter :authenticate_user!

  def index
    @current_user = current_user
  end

  def status
  end
end
