class AdminConstraint
  def match?(request)
    return false

    #return false unless request.session[:user_id]
    #user = User.find request.session[:user_id]
    #user.name == 'root'
  end
end
