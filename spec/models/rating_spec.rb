# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:statistics).class_name('Statistics') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:average) }
    it { is_expected.to validate_presence_of(:est_amount) }
    it { is_expected.to validate_presence_of(:values_sum) }
    it { is_expected.to validate_presence_of(:last_est_time) }
    it { is_expected.to validate_presence_of(:last_est_id) }
  end

  describe 'scopes' do
    describe '#top' do
      context 'when we have ratings' do
        before do
          create_list :post, 5, :with_user_statistics_evaluations_ratings
        end

        after { Timecop.return }

        it 'finds specified amount of ratings' do
          amount = 3
          result = described_class.top(amount)
          expected_result = 3
          expect(result.count).to be(expected_result)
        end

        it 'finds specified amount of ratings in DESC order by .average' do
          amount = 3
          result = described_class.top(amount).to_a
          expected_result = result.sort_by { |h| -h[:average] }
          expect(result).to eql(expected_result)
        end

        it 'generates correct sql query' do
          expected_result = 'SELECT  "ratings".* FROM "ratings" ORDER BY average DESC LIMIT 3'
          amount = 3
          result = described_class.top(amount)
          expect(result.to_sql).to eql(expected_result)
        end
      end

      context 'when we dont have ratings' do
        before do
          create_list :post, 5, :with_user
        end

        it 'finds 0 ratings' do
          amount = 3
          result = described_class.top(amount)
          expected_result = 0
          expect(result.count).to be(expected_result)
        end
      end
    end
  end

  describe '#formatted_avg' do
    let(:post) { create :post, :with_user_statistics_evaluations_ratings }

    it 'returns value in correct format' do
      result = post.statistics.ratings.first.formatted_avg
      expect(result).to be_instance_of(String)
    end
  end
end
