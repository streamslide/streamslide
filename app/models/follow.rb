class Follow < ActiveRecord::Base
  attr_accessible :following_user_id, :user_id
  validates :user_id, presence: true
  validates :following_user_id, presence: true

  belongs_to :user
  belongs_to :following_user, class_name: 'User', foreign_key: 'following_user_id'

end
