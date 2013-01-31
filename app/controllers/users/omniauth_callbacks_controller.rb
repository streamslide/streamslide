class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #note methods must be same name as provider
  #All information retrieved from provider by 
  #OmniAuth is available as a hash at request.env["omniauth.auth"].
  
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      #We pass the :event => :authentication to the sign_in_and_redirect method to 
      #force all authentication callbacks to be called.
      sign_in_and_redirect @user, :event => :authentication 
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    # Or alternatively,
    # raise ActionController::RoutingError.new('Not Found')
  end
end
