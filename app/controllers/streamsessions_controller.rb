class StreamsessionsController < ApplicationController

  def generate 
    rand_str = SecureRandom.hex(16)
    usr_name = current_user.username
    channel_name = "/#{usr_name}/#{rand_str}"
    $redis.set "#{usr_name}:session" , {id: rand_str, slug: params[:slug_name]}.to_json
    url = "stream#{channel_name}"

    respond_to do |f|
      f.json {render :json=>{'channel'=>channel_name, 'url'=>root_url+url}.to_json}
    end
  end

  def index 
    host = params[:username]
    host = User.find_by_username(host)
    channel_info = JSON.parse($redis.get "#{host.username}:session")
    id = channel_info["id"]
    slug = channel_info["slug"]

    @slide = Slide.where(:user_id =>host.id , :slug => slug).first
    
    channel_name = "/#{host.username}/#{id}"
    
    render 'slide/streaming/index', :locals=>{channel_name: channel_name}
  end
end
