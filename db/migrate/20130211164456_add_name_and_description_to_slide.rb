class AddNameAndDescriptionToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :name, :text
    add_column :slides, :description, :text
  end
end
