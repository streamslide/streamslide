class FayemessagesController < ApplicationController
  def auth_publish
    if current_user.nil?
      render :status => 404 and return
    end

    unless params['data']['content']['ext'].nil?
      params['data']['content']['ext']['avatar'] = current_user.image_url
      params['data']['content']['ext']['usrname'] = current_user.username
    end

    data = params['data']
    channel = params['channel']
    mes = {:channel => channel, :data => data}
    uri = URI.parse(Settings.eventserv)
    Net::HTTP.post_form(uri, :message => mes.to_json) 
    render :nothing => true
  end
end
