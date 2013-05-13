class CreateStyleGames < ActiveRecord::Migration

  def up
    create_table :refinery_style_games do |t|
      t.string :name
      t.string :description
      t.belongs_to :user
      t.integer :position

      t.timestamps
    end

  end

  def down

    drop_table :refinery_style_games

  end

end
