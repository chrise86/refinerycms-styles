module Refinery
  module Style
    class Style < Refinery::Core::BaseModel
      self.table_name = 'refinery_styles'

      attr_accessible :name, :url, :position

      belongs_to :game
      
      acts_as_indexed :fields => [:name, :url]

      validates :name, :presence => true, :uniqueness => true
    end
  end
end
