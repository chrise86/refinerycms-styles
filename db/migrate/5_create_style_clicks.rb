class CreateStyleClicks < ActiveRecord::Migration
  def change
    create_table :refinery_style_clicks do |t|
      t.belongs_to :game
      t.string :choices
      t.belongs_to :result
      t.string :remote_ip
      t.string :agent

      t.timestamps
    end
  end
end
