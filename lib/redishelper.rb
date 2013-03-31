class Redishelper
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

    @db_instance.set "#{host}:streamslide:state" , slug_inf.to_json
    @db_instance.set "#{host}:streamslide:master_key", masterkey
    @db_instance.set "#{host}:streamslide:auth_key", sessionkey
    @db_instance.set "#{host}:streamslide:question_incr", 0

    return masterkey
  end

  def get_current_state host
    return @db_instance.get "#{host}:streamslide:state"
  end

  def set_current_state host, opts

  end
  
  def get_session_auth_key host
    return @db_instance.get "#{host}:streamslide:auth_key"
  end

  def add_new_question host, usr, slug, ques
    q_id = @db_instance.get "#{host}:streamslide:question_incr"

    @db_instance.set "#{host}:streamslide:question_incr", q_id
    @db_instance.set "#{host}:streamslide:question:#{q_id}", {content: ques, usr: {name: usr.username, avatar: usr.image_url}}.to_json
    @db_instance.sadd "#{host}:streamslide:questions", "#{host}:streamslide:question:#{q_id}"
    @db_instance.incr "#{host}:streamslide:question_incr" #generate increment id for questions
  end

  def get_questions host, slug
    q_collection = []

    q_set = @db_instance.smembers "#{host}:streamslide:questions"
    q_set.each do |q|
      _q = @db_instance.get q 
      q_collection << _q
    end
    return q_collection
  end

  private   
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end
