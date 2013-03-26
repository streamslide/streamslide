class FayemessagesController < ApplicationController
  def publish
    unless params['data']['content']['ext'].nil?
      params['data']['content']['ext']['avatar'] = current_user.image_url
    end

    data = params['data']
    channel = params['channel']
    mes = {:channel => channel, :data => data, :ext => {:auth_token => ENV['FAYE_TOKEN']}}
    uri = URI.parse(Settings.defaults[:event_server])
    Net::HTTP.post_form(uri, :message => mes.to_json) 
    render :nothing => true
  end
end
