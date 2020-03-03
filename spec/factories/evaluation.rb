# frozen_string_literal: true

FactoryBot.define do
  factory :evaluation, class: 'Evaluation' do
    value { 4 }
    association :post, factory: :post, strategy: :create
  end
end
