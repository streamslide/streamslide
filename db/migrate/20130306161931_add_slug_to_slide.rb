class AddSlugToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :slug, :string

    Slide.all.each do |slide|
      slide.send(:update_slug)
    end
  end
end
