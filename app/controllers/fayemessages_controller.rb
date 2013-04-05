class FayemessagesController < ApplicationController
  before_filter :setup_redis

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
   
    case data['content']['controller']
    when 'chat'
      chatmessage_proc(data)
    when 'question'
      command = data['content']['command']
      case command
      when 'add'
        qid = questions_proc(data)
        data['content']['ext']['qid'] = qid
      when 'voteup'
        num = question_voteup_proc(data)
        data['content']['ext']['votenum'] = num.to_json 
      when 'votedown'
        num = question_votedown_proc(data)
        data['content']['ext']['votenum'] = num.to_json 
      else
      end
    else
    end

    mes = {:channel => channel, :data => data}
    uri = URI.parse(Settings.eventserv)
    Net::HTTP.post_form(uri, :message => mes.to_json)
    render :nothing => true
  end
  
  private
  def questions_proc(mes)
    ques = mes['content']['ext']['messagecontent']
    host = mes['content']['ext']['host']
    slug = mes['content']['ext']['slug'] 
    qid = @rhelper.add_new_question(host, current_user.username, slug, ques)

    return qid
  end
  
  def question_voteup_proc(mes)
    host = mes['content']['ext']['host']
    id = mes['content']['ext']['qid']

    votenum = @rhelper.question_voteup(host, id)
    return votenum
  end

  def question_votedown_proc(mes)
    host = mes['content']['ext']['host']
    id = mes['content']['ext']['qid']

    votenum = @rhelper.question_votedown(host, id)
    return votenum 
  end

  def chatmessage_proc(mes)
  end
  
  private
  def setup_redis
    @rhelper = Redishelper.new($redis)
  end 
end
