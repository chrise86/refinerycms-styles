
FactoryGirl.define do
  factory :game, :class => Refinery::Style::Game do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

