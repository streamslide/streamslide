class FayemessagesController < ApplicationController
  def publish
    params['data']['content']['ext']['avatar'] = current_user.image_url

    data = params['data']
    channel = params['channel']
    mes = {:channel => channel, :data => data, :ext => 'token'}
    
    uri = URI.parse(Settings.defaults[:event_server])
    Net::HTTP.post_form(uri, :message => mes.to_json) 

    render :nothing => true
  end
end
