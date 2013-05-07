module Refinery
  module Style
    class Game < Refinery::Core::BaseModel

      attr_accessible :name, :description, :styles_attributes, :image_categories_attributes, :position

      has_many :styles
      has_many :image_categories
      has_many :images, through: :image_categories
      accepts_nested_attributes_for :styles, :allow_destroy => true
      accepts_nested_attributes_for :image_categories, :allow_destroy => true

      acts_as_indexed :fields => [:name, :description]

      validates :name, :presence => true, :uniqueness => true

      def serializable_hash(options={})
        options = { 
          include: :image_categories
        }.update(options)
        super(options)
      end

      def make_choice images
        center = get_center(images)
        ret = center.max_by{|k,v|v} rescue center.to_a[0]
        styles.find(ret[0])
      end

      def get_center points
        sum = {}
        fields = styles.pluck(:id)
        fields.each do |field|
          sum[field] = 0.0
          images.each do |point|
            sum[field] += point.dynamic_attributes.fetch(field.to_s, 0).to_f
          end
        end

        ret = {}
        length = points.length
        fields.each do |field|
          ret[field] = 0.0
          points.each do |point|
            ret[field] += point.dynamic_attributes.fetch(field.to_s, 0).to_f
          end
          ret[field] /= sum[field]
        end
        logger.info "  Result: #{ret}"
        ret
      end
    end
  end
end
