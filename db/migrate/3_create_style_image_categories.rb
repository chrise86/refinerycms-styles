class CreateStyleImageCategories < ActiveRecord::Migration

  def up
    create_table :refinery_style_image_categories do |t|
      t.string :name
      t.string :description
      t.integer :match_count
      t.belongs_to :game
      t.integer :position

      t.timestamps
    end

  end

  def down

    drop_table :refinery_style_image_categories

  end

end
