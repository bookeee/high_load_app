# frozen_string_literal: true

FactoryBot.define do
  factory :caching, class: 'Settings::Caching' do
    top_posts_caching_time { 60 }
    top_posts_limit { 10 }
  end
end
