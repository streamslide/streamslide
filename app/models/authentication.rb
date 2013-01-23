class Authentication < ActiveRecord::Base
  attr_accessible :provider, :token, :uid, :user_id
  belongs_to :user

  def update_token auth
    self.token = auth['credentials']['token']
    self.save
  end
end
