# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: 'Persona::User' do
    sequence(:login) { |n| "test_login_#{n}" }

    before(:create) do |user|
      create(:session, users: [user])
    end

    trait :with_post do
      before(:create) do |user|
        create(:post, user: user)
      end
    end
  end
end
