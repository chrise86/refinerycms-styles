module Refinery
  module Style
    class Game < Refinery::Core::BaseModel

      attr_accessible :name, :description, :styles_attributes, :image_categories_attributes, 
        :css_file_id, :custom_style, :position

      serialize :custom_style

      has_many :styles
      has_many :image_categories
      has_many :images, through: :image_categories

      has_many :clicks
      has_many :clicks_images, through: :clicks

      accepts_nested_attributes_for :styles, :allow_destroy => true
      accepts_nested_attributes_for :image_categories, :allow_destroy => true

      belongs_to :css_file, :class_name => 'Refinery::Resource'

      acts_as_indexed :fields => [:name, :description]

      validates :name, :presence => true, :uniqueness => true

      def self.serialized_attr_accessor(serialize, *args)
        args.each do |method_name|
          define_method method_name do
            (self.send(serialize) || {})[method_name]
          end

          define_method "#{method_name}=" do |value|
            self.send("#{serialize}=", {}) unless self.send(serialize)
            self.send(serialize)[method_name] = value
          end
        end

        attr_accessible *args
      end

      serialized_attr_accessor :custom_style, 
        :display_photo_names, :background_color, :title_text_align, :photo_name_text_align,
        :title_text_color, :description_text_color, :photo_name_text_color, 
        :title_font_family, :description_font_family, :photo_name_font_family, 
        :title_font_size, :description_font_size, :photo_name_font_size,
        :photo_height, :photo_width

      def serializable_hash(options={})
        options = { 
          include: :image_categories
        }.update(options)
        super(options)
      end

      def sample_categories
        categories = []
        last_images = curr_images = []
        image_categories.each do |category|
          next if category.images.length < 2
          (category.match_count || 1).times do
            curr_images = category.images.sample(2) while curr_images == last_images
            last_images = curr_images
            categories << ImageCategory.new(
              name: category.name, 
              description: category.description,
              images: curr_images
            )
          end
        end
        categories
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
          images.each do |point|
            sum[field] ||= {}
            sum[field][point.image_category_id] ||= 0.0
            sum[field][point.image_category_id] += 
              point.dynamic_attributes.fetch(field.to_s, 0).to_f
          end
        end

        ret = {}
        length = points.length
        fields.each do |field|
          ret[field] = 0.0
          points.each do |point|
            ret[field] += 
              point.dynamic_attributes.fetch(field.to_s, 0).to_f / 
              sum[field][point.image_category_id]
          end
        end
        logger.info "  Result: #{ret}"
        ret
      end

      def trace env, choices, result
        # Thread.new do
          click = clicks.new
          click.trace env, choices, result
          click.save

        #   ActiveRecord::Base.connection.close
        # end
      end

      def analyze_clicks(type)
        options = {
          year: {
            group_by: "%Y"
          },
          month: {
            group_by: "%Y/%m",
          },
          day: {
            group_by: "%Y/%m/%d",
          },
          hour: {
            group_by: "%Y/%m/%d %H",
          }
        }

        group_by = options[type][:group_by]

        ret = {}
        clicks.group("strftime('#{group_by}', created_at)")
        .count.each do |key, value|
          ret[Time.zone.parse(key)] = value
        end
        ret
      end

      def flot_clicks type = :auto
        return [].to_json unless clicks.any?
        if type == :auto
          dt = Time.now - clicks.first.created_at
          if dt > 10.year
            type = :year
          elsif dt > 1.year
            type = :month
          elsif dt > 10.day
            type = :day
          else
            type = :hour
          end
        end

        data = analyze_clicks(type).map do |time, value| 
          [time.to_i * 1000, value]
        end

        [{ data: data, bars: { barWidth: (1.send(type).to_i * 750) }}].to_json
      end

      def analyze_styles conditions = {}
        clicks_images.where(conditions).group("image").count
      end

      def flot_styles
        formater = Proc.new do |image, value|
          { label: image.name, data: value}
        end

        ret = {}
        ret[:all_categories] = analyze_styles.map &formater

        image_categories.each do |image_category|
          key = image_category.name.parameterize('_')
          ret[key] = analyze_styles(:image_id => image_category.images).map &formater
        end

        ret.each do |key, value|
          ret[key]
        end

        ret.to_json
      end

      def analyze_results
        clicks.group("result").count
      end

      def flot_results
        ret = []

        analyze_results.map do |style, value|
          ret << { label: style.name, data: value }
        end

        ret.to_json
      end
    end
  end
end
