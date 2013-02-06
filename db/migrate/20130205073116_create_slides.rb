class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.integer :user_id
      t.integer :pages
      t.string :s3_key
      t.string :filename

      t.timestamps
    end
  end
end
