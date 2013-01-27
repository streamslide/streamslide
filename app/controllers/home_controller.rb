class HomeController < ApplicationController
  def index
      #@user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
  end
end
