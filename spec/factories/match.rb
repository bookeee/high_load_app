# frozen_string_literal: true

FactoryBot.define do
  factory :match, class: 'Match' do
    sequence(:ip) { |n| "192.168.0.#{n}" }
    logins { %w[login_one login_two login_three] }
  end
end
