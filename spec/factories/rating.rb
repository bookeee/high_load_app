# frozen_string_literal: true

FactoryBot.define do
  factory :rating, class: 'Rating' do
    sequence(:average) { |n| (10 + n) }
    est_amount   { 10 }
    values_sum { 50 }
    last_est_time { DateTime.now }
    last_est_id { 1 }
  end
end
