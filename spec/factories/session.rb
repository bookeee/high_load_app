# frozen_string_literal: true

FactoryBot.define do
  factory :session, class: 'Persona::Session' do
    ip { Faker::Internet.ip_v4_address }
  end
end
