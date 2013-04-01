class StreamsessionsController < ApplicationController
  before_filter :set_up_redis_helper

  def generate 
    rand_str = SecureRandom.hex(16)
    usr_name = current_user.username

    channel_name = "/#{usr_name}/#{params[:slug_name]}"
    ret = @rhelper.generate_session usr_name, {slug: params[:slug_name], page: params[:page]}
    render :status=>404 and return unless ret

    url = "stream#{channel_name}"

    respond_to do |f|
      f.json {render :json=>{'channel'=>channel_name, 'url'=>root_url+url, 'token'=>ret}.to_json}
    end
  end

  def index 
    host = User.find_by_username(params[:username])
    session_token = @rhelper.get_session_auth_key host.username
    channel_info = JSON.parse(@rhelper.get_current_state(host.username))
    id = channel_info["id"]
    slug = channel_info["slug"]

    @slide = Slide.where(:user_id =>host.id , :slug => slug).first
    channel_name = "/#{host.username}/#{slug}"
    
    render 'slide/viewer/index', :locals=>{channel_name: channel_name, session_token: session_token, slug: slug, host: host.username}
  end

  def set_page
    page = params[:page]
    usr_name = current_user.username
    channel_info = JSON.parse($redis.get "#{usr_name}:streamslide:state")
    channel_info["page"] = page
    $redis.set "#{usr_name}:streamslide:state" , channel_info.to_json
    render :nothing => true
  end

  def get_page
    host = params[:username] #[TODO]change name to host 
    state_json= $redis.get "#{host}:streamslide:state"
    respond_to do |f|
      f.json {render :json => state_json}
    end
  end

  def add_question
    host = params[:host]
    u_current = current_user
    @rhelper.add_new_question host, current_user, params[:slug], params[:question]
  end

  def get_questions
    host = params[:host]
    ret = @rhelper.get_questions host, params[:slug]
  end

  private
  def set_up_redis_helper
    @rhelper = Redishelper.new($redis)
  end
end
