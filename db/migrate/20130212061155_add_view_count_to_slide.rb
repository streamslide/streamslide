class AddViewCountToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :view_count, :integer, :default => 1
  end
end
