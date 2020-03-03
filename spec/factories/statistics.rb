# frozen_string_literal: true

FactoryBot.define do
  factory :statistics, class: 'Statistics' do
    transient do
      evaluation { false }
    end
    trait :with_rating do
      before(:create) do |statistics, evaluator|
        create(:rating, statistics: statistics, last_est_id: evaluator.evaluation.id)
      end
    end
  end
end
