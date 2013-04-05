module StreamKeyGenerator
  def state host 
    "#{host}:streamslide:state"
  end 

  def masterkey host
    "#{host}:streamslide:master_key"
  end

  def authkey host
    "#{host}:streamslide:auth_key"
  end
end

module QuestionKeyGenerator 
  def questions_uniqueid host
    "#{host}:streamslide:question_incr"
  end

  def question host, id
    "#{host}:streamslide:question:#{id}"
  end

  def question_all host
    "#{host}:streamslide:questions"
  end
end

class Redishelper
  include StreamKeyGenerator
  include QuestionKeyGenerator

  def initialize instance 
    @db_instance = instance
  end

  def generate_session host, slug_inf={}
    require 'securerandom'

    if slug_inf.blank? or slug_inf[:slug].blank? or slug_inf[:page].blank?
      return false
    end

    masterkey = SecureRandom.hex(16)
    sessionkey = SecureRandom.hex(16)

    @db_instance.set state(host) , slug_inf.to_json
    @db_instance.set masterkey(host), masterkey
    @db_instance.set authkey(host), sessionkey
    @db_instance.set questions_uniqueid(host), 0

    return masterkey
  end

  def get_current_state host
    return @db_instance.get state(host)
  end

  def set_current_state host, opts

  end
  
  def get_session_auth_key host
    return @db_instance.get authkey(host) 
  end

  def add_new_question host, usr, slug, ques
    id = @db_instance.get questions_uniqueid(host) 

    @db_instance.hmset question(host, id), 'content',ques,'usr',usr,'voteup',0,'votedown',0
    @db_instance.sadd question_all(host), question(host, id) 
    @db_instance.incr questions_uniqueid(host) 
    return id
  end

  def get_questions host, slug
    q_collection = []

    q_set = @db_instance.smembers question_all(host) 
    q_set.each do |q|
      _q = @db_instance.get q 
      q_collection << _q
    end
    return q_collection
  end
  
  def question_voteup host, qid
    vup = Integer((@db_instance.hmget question(host, qid), 'voteup')[0])
    vup += 1 
    @db_instance.hmset question(host, qid), 'voteup', vup
    vdown = Integer((@db_instance.hmget question(host, qid), 'votedown')[0])
    return {:up=>vup, :down=>vdown}
  end

  def question_votedown host, qid
    vdown = Integer((@db_instance.hmget question(host, qid), 'votedown')[0])
    vdown -= 1
    @db_instance.hmset question(host, qid), 'votedown', vdown
    vup = Integer((@db_instance.hmget question(host, qid), 'voteup')[0])
    return {:up=>vup, :down=>vdown}
  end

  private   
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end
