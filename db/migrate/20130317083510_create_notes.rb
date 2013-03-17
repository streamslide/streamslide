class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :pagenum
      t.integer :slide_id
      t.integer :user_id
      t.integer :top
      t.integer :left
      t.integer :width
      t.integer :height
      t.text :content

      t.timestamps
    end

     add_index :notes, :user_id
     add_index :notes, :pagenum
     add_index :notes, :slide_id
  end
end
