class CreateStyleImages < ActiveRecord::Migration

  def up
    create_table :refinery_style_images do |t|
      t.string :name
      t.string :dynamic_attributes
      t.belongs_to :image_category
      t.belongs_to :image
      t.integer :position

      t.timestamps
    end

  end

  def down
    
    drop_table :refinery_style_images

  end

end
