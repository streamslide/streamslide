# This controller handles action which facebook call to our server
class AuthenticationsController < ApplicationController

#  def create #[TODO]remove this controller
#    auth = request.env["omniauth.auth"]
#
#    # Try to find authentication first
#    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
#
#    if authentication
#      sign_in_old_user authentication, auth
#    else
#      create_new_user authentication, auth
#    end
#  end
#
#  private
#
#  def sign_in_old_user(authentication, auth)
#    authentication.update_token auth
#    flash[:notice] = "Signed in successfully."
#    sign_in_and_redirect(:user, authentication.user)
#  end
#
#  def create_new_user(authentication, auth)
#    user = User.new
#    user.apply_omniauth(auth)
#
#    if user.save(:validate => false)
#      flash[:notice] = "Account created and signed in successfully."
#      sign_in_and_redirect(:user, user)
#    else
#      flash[:error] = "Error while creating a user account. Please try again."
#      redirect_to root_url
#    end
#  end

end
