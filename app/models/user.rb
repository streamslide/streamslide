class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
  has_many :authentications, :dependent => :delete_all

  def apply_omniauth(auth)
    self.email = auth.info['email']
    self.image_url = auth.info['image']
    authentications.build(
      :provider => auth['provider'], :uid => auth['uid'],
      :token => auth['credentials']['token'])
  end
end
