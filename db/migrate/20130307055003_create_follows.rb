class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :following_user_id
      t.integer :user_id

      t.timestamps
    end

    add_index :follows, :user_id
    add_index :follows, :following_user_id
  end
end
