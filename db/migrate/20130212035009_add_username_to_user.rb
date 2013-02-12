class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :text
    add_index :users, :username, :unique => true
  end
end
