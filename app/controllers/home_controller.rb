class HomeController < ApplicationController
  def index
      binding.pry
      #@user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
  end
end
