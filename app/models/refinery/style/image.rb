module Refinery
  module Style
    class Image < Refinery::Core::BaseModel

      attr_accessible :name, :image_category, :image_id, :dynamic_attributes, :position
      
      serialize :dynamic_attributes

      belongs_to :image_category
      belongs_to :image, :class_name => '::Refinery::Image'
      
      acts_as_indexed :fields => [:name]

      def image_url
        image.url if image
      end

      def thumb_url
        image.thumbnail('106x106#c').url if image
      end

      def serializable_hash(options={})
        options = { 
          methods: [:image_url, :thumb_url]
        }.update(options)
        super(options)
      end
    end
  end
end
