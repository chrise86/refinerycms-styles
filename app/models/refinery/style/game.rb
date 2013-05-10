module Refinery
  module Style
    class Game < Refinery::Core::BaseModel

      attr_accessible :name, :description, :styles_attributes, :image_categories_attributes, :position

      has_many :styles
      has_many :image_categories
      has_many :images, through: :image_categories

      has_many :clicks
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

      def trace env, choices
        Thread.new do
          click = clicks.new
          click.trace env, choices
          click.save

          ActiveRecord::Base.connection.close
        end
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

      def analyze_styles
        count = {}
        clicks.pluck(:choices).each do |choices|
          choices.split(',').each do |choice|
            c = choice.to_i
            count[c] ||= 0
            count[c] += 1
          end
        end
        count
      end

      def flot_styles
        image_map = {}
        ret = {}
        ret[:all_categories] = []
        image_categories.each do |image_category|
          key = image_category.name.parameterize('_')
          image_map[key] = {}
          ret[key] = []
          image_category.images.each do |image|
            image_map[key][image.id] = image.name
          end
        end

        analyze_styles.map do |id, value|
          column = nil
          image_map.each do |key, map|
            if map.include? id
              column = { label: map[id], data: value }
              ret[key] << column
            end
          end
          ret[:all_categories] << column
        end

        ret.to_json
      end
    end
  end
end

class DateTime
  def all_months_until to
    from = self
    from, to = to, from if from > to
    m = DateTime.new from.year, from.month
    result = []
    while m <= to
      result << m
      m >>= 1
    end
    
    result << m
  end
end