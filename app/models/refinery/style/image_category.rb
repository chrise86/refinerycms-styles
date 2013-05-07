module Refinery
  module Style
    class ImageCategory < Refinery::Core::BaseModel

      attr_accessible :name, :description, :match_count, :images_attributes, :images, :position
      
      belongs_to :game

      has_many :images
      accepts_nested_attributes_for :images, :allow_destroy => true

      acts_as_indexed :fields => [:name]

      def serializable_hash(options={})
        options = { 
          include: :images
        }.update(options)
        super(options)
      end
    end
  end
end
