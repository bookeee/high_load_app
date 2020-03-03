# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Evaluation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:post).class_name('Post') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:value), in: 1..5 }
  end

  describe 'scopes' do
    describe '#previous_by_request' do
      context 'when we have evaluations with older timestamp' do
        before do
          Timecop.freeze DateTime.current
          create_list :post, 5, :with_user_statistics_evaluations_ratings, created_at: (DateTime.now - 1.day)
        end

        after { Timecop.return }

        it 'finds all evaluations' do
          result = described_class.previous_by_request(DateTime.current)
          expect(result.count).to be(5)
        end

        it 'generates correct sql query' do
          expected_result = 'SELECT "evaluations".* FROM "evaluations" WHERE '\
                            "(created_at <= '#{DateTime.current.strftime('%F %T.%6N')}')"
          result = described_class.previous_by_request(DateTime.current)
          expect(result.to_sql).to eql(expected_result)
        end
      end

      context 'when we have evaluations with newest timestamp' do
        before do
          Timecop.freeze DateTime.current
          create_list :post, 5, :with_user_statistics_evaluations_ratings, created_at: (DateTime.now + 1.day)
        end

        after { Timecop.return }

        it 'finds 0 evaluations' do
          result = described_class.previous_by_request(DateTime.current)
          expect(result.count).to be(0)
        end
      end

      context 'when we dont have evaluations' do
        it 'finds 0 evaluations' do
          result = described_class.previous_by_request(DateTime.current)
          expect(result.count).to be(0)
        end
      end
    end

    describe '#rating' do
      context 'when we have rating' do
        before do
          post = create :post, :with_user_statistics_evaluations_ratings
          @evaluation = post.evaluations.first
        end

        it 'finds rating' do
          result = @evaluation.rating
          expected_result = Rating
          expect(result).to be_a(expected_result)
        end
      end

      context 'when we dont have rating' do
        before do
          post = create :post, :with_user_statistics_evaluations
          @evaluation = post.evaluations.first
        end

        it 'returns nil' do
          result = @evaluation.rating
          expected_result = nil
          expect(result).to eql(expected_result)
        end
      end
    end
  end
end
