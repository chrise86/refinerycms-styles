class CreateStyleStyles < ActiveRecord::Migration

  def up
    create_table :refinery_styles do |t|
      t.string :name
      t.string :url
      t.belongs_to :game
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-style"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/style/styles"})
    end

    drop_table :refinery_styles

  end

end
