class Note < ActiveRecord::Base
  attr_accessible :content, :height, :left, :pagenum, :slide_id, :top, :user_id, :width

  belongs_to :slide

end
