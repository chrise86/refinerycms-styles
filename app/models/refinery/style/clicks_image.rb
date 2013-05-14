class Refinery::Style::ClicksImage < ActiveRecord::Base

  belongs_to :click
  belongs_to :image

end
