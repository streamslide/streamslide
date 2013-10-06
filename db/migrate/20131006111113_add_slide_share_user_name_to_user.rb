class AddSlideShareUserNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :slideshare_user_name, :string
  end
end
