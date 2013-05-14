class CreateStyleClicksImages < ActiveRecord::Migration
  def change
    create_table :refinery_style_clicks_images do |t|
      t.belongs_to :click
      t.belongs_to :image
    end
  end
end
