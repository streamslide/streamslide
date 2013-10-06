require 'digest/md5'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:login]

  has_many :slides, :dependent => :destroy
  has_many :follows, :dependent => :destroy

  attr_accessor :login
  attr_accessible :email, 
    :slideshare_user_name,
    :name, 
    :image_url, 
    :username,
    :password, 
    :password_confirmation,
    :remember_me, 
    :provider, 
    :uid, 
    :login

  validates_uniqueness_of :username

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where([
          "lower(username) = :value OR lower(email) = :value",
          { :value => login.downcase }
      ]).first
    else
      where(conditions).first
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first

    unless user
      user = User.find_by_email(auth.info.email)
      if user
        user.name =  auth.extra.raw_info.name
        user.provider = auth.provider
        user.uid = auth.uid
        user.password = Devise.friendly_token[0,20]
        user.image_url = auth.info.image
      else
        user = User.create(name: auth.extra.raw_info.name,
                           provider: auth.provider,
                           uid: auth.uid,
                           email: auth.info.email,
                           password: Devise.friendly_token[0,20],
                           image_url: auth.info.image)
      end
    end
    user
  end

  def avatar_url
    if image_url.nil? then
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=50"
    else
      image_url
    end
  end

  def followed?(user_id)
    !Follow.where("user_id = ? AND following_user_id = ?", self.id, user_id).empty?
  end

end
