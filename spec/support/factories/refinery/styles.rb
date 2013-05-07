
FactoryGirl.define do
  factory :style, :class => Refinery::Style::Style do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

