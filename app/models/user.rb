class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :name,
                  :password, :password_confirmation, 
                  :remember_me, 
                  :provider, :uid
  has_many :authentications, :dependent => :delete_all
 
  def self.new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    #Your application must take precautions if using User.find_by_email 
    #to link an existing User with a Facebook account.
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                          provider:auth.provider,
                          uid:auth.uid,
                          email:auth.info.email,
                          password:Devise.friendly_token[0,20]
                          )
    end
    user
  end
end
