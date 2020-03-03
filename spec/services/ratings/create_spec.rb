# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create' do
  let(:post) { create :post, :with_user_statistics_evaluations_ratings }
  let(:current_evaluation) { create :evaluation, post: post }
  let(:request_timestamp) { DateTime.now }

  before do
    @ratings_create = Services::Ratings::Create.new(post, current_evaluation, request_timestamp)
  end

  describe '#initialize' do
    it 'initializes correct instance' do
      expected_result = post
      expect(@ratings_create.instance_variable_get(:@post)).to eq(expected_result)

      expected_result = current_evaluation
      expect(@ratings_create.instance_variable_get(:@current_evaluation)).to eq(expected_result)

      expected_result = request_timestamp
      expect(@ratings_create.instance_variable_get(:@request_timestamp)).to eq(expected_result)
    end
  end

  describe '#call' do
    it 'calls create' do
      allow(@ratings_create).to receive(:create).and_return(true)
      @ratings_create.call
      expect(@ratings_create).to have_received(:create)
    end
  end

  describe '#create' do
    describe 'when we have correct data' do
      it 'creates new rating for given post' do
        before_creation = post.statistics.ratings.count
        @ratings_create.send(:create)
        result = post.statistics.ratings.count
        expected_result = before_creation + 1
        expect(result).to eql(expected_result)
      end
    end
  end

  describe '#last_est_id' do
    it 'returns id of current evaluation' do
      expected_result = current_evaluation.id
      result = @ratings_create.send(:last_est_id)
      expect(result).to eql(expected_result)
    end
  end

  describe '#est_amount' do
    it 'returns amount of evaluations' do
      expected_result = @ratings_create.send(:evaluations).count
      result = @ratings_create.send(:est_amount)
      expect(result).to eql(expected_result)
    end
  end

  describe '#last_est_time' do
    it 'returns @request_timestamp' do
      expected_result = request_timestamp
      result = @ratings_create.send(:last_est_time)
      expect(result).to eql(expected_result)
    end
  end

  describe '#evaluations' do
    it 'returns previous evaluations + current evaluation' do
      previous_evaluations = @ratings_create.send(:previous_evaluations)
      expected_result = previous_evaluations << current_evaluation
      result = @ratings_create.send(:evaluations)

      expect(result).to eql(expected_result)
    end
  end

  describe '#previous_evaluations' do
    it 'returns previous evaluations by given time' do
      expected_result = 2
      result = @ratings_create.send(:previous_evaluations).count
      expect(result).to eql(expected_result)
    end
  end

  describe '#values_sum' do
    it 'calculates sum of values' do
      expected_result = 12
      result = @ratings_create.send(:values_sum)
      expect(result).to eql(expected_result)
    end
  end

  describe '#values_sum' do
    it 'calculates average of values' do
      expected_result = 4.to_d
      result = @ratings_create.send(:average)
      expect(result).to eql(expected_result)
    end

    it 'returns BigDecimal' do
      result = @ratings_create.send(:average)
      expected_class = BigDecimal
      expect(result).to be_instance_of(expected_class)
    end
  end
end
