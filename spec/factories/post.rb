# frozen_string_literal: true

FactoryBot.define do
  factory :post, class: 'Post' do
    title { 'test_title' }
    content { 'test content' }
    transient do
      created_at { false }
    end
  end

  trait :with_user do
    before(:create) do |post|
      create(:user, posts: [post])
    end
  end

  trait :with_user_statistics do
    before(:create) do |post|
      create(:user, posts: [post])
      create(:statistics, post: post)
    end
  end

  trait :with_user_statistics_evaluations do
    before(:create) do |post|
      create(:user, posts: [post])
      create(:evaluation, post: post)
    end
  end

  trait :with_user_statistics_evaluations_ratings do
    before(:create) do |post, evaluator|
      create(:user, posts: [post])
      create(:evaluation, post: post, created_at: evaluator.created_at) do |evaluation|
        create(:statistics, :with_rating, post: post, evaluation: evaluation)
      end
    end
  end
end
