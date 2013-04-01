class FayemessagesController < ApplicationController
  def auth_publish
    if current_user.nil?
      render :status => 404 and return
    end
    data = params['data']
    channel = params['channel']

    unless data['content']['ext'].nil?
      data['content']['ext']['avatar'] = current_user.image_url
      data['content']['ext']['usrname'] = current_user.username
    end
   
    mes = {:channel => channel, :data => data}
    uri = URI.parse(Settings.eventserv)
    Net::HTTP.post_form(uri, :message => mes.to_json) 

    case data['content']['controller']
    when 'chat'
      chatmessage_proc(data)
    when 'question'
      questions_proc(data)
    else
    end

    render :nothing => true
  end
  
  private
  def questions_proc(mes)
    ques = mes['content']['ext']['messagecontent']
    host = mes['content']['ext']['host']
    slug = mes['content']['ext']['slug'] 
    Question.new(:host=>host, 
                 :usr=>current_user.username, 
                 :slug=>slug,
                 :content=>ques).add!

  end

  def chatmessage_proc(mes)
  end
   
end
