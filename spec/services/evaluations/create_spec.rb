# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create' do
  let(:args) { { post_id: 1, value: 3 } }
  let(:request_timestamp) { DateTime.now }

  before do
    Timecop.freeze DateTime.current
    @create_evaluation = Services::Evaluations::Create.new(args, request_timestamp)
  end

  after { Timecop.return }

  describe '#initialize' do
    it 'initializes correct instance' do
      expected_post_id = 1
      expect(@create_evaluation.instance_variable_get(:@post_id)).to eq(expected_post_id)

      expected_value = 3
      expect(@create_evaluation.instance_variable_get(:@value)).to eq(expected_value)

      expected_request_timestamp = DateTime.now
      expect(@create_evaluation.instance_variable_get(:@request_timestamp)).to eq(expected_request_timestamp)
    end
  end

  describe '#set_post' do
    context 'when we have post' do
      before do
        create :post, :with_user_statistics_evaluations_ratings, id: 1
      end

      it 'finds post by post_id' do
        expected_result = 1
        expect(@create_evaluation.send(:set_post).id).to eq(expected_result)
      end
    end

    context 'when we dont have post' do
      it 'returns nil' do
        expected_result = nil
        expect(@create_evaluation.send(:set_post)).to eq(expected_result)
      end
    end
  end

  describe '#calculate_rating' do
    before do
      Timecop.freeze DateTime.current
      @post = create :post, :with_user_statistics_evaluations_ratings
    end

    after { Timecop.return }

    it 'calls Services::Ratings::Create.new(@post, @evaluation, @request_timestamp).call' do
      evaluation = @post.statistics.ratings.last
      request_timestamp = DateTime.new
      service = Services::Ratings::Create

      @create_evaluation.instance_variable_set(:@post, @post)
      @create_evaluation.instance_variable_set(:@evaluation, evaluation)
      @create_evaluation.instance_variable_set(:@request_timestamp, request_timestamp)

      instance = double('create')
      allow(service).to receive(:new).with(@post, evaluation, request_timestamp).and_return(instance)
      allow(instance).to receive(:call).and_return([])

      @create_evaluation.send(:calculate_rating)

      expect(service).to have_received(:new).with(@post, evaluation, request_timestamp)
      expect(instance).to have_received(:call)
    end
  end

  def create_evaluation
    @evaluation = @post.evaluations.create!(value: @value)
  end

  describe '#create_evaluation' do
    before do
      @post = create :post, :with_user
    end

    it 'creates new evaluation with correct value' do
      value = 5
      result = @post.evaluations.create!(value: value)

      expected_class = Evaluation
      expect(result).to be_instance_of(expected_class)
      expected_value = 5
      expect(result.value).to eql(expected_value)
    end
  end

  describe '#call' do
    context 'when we have correct data' do
      before do
        @post = create :post, :with_user_statistics, id: 1
      end

      it 'returns evaluation' do
        result = @create_evaluation.call
        expected_class = Evaluation
        expect(result).to be_instance_of(expected_class)
      end
    end

    context 'when we have wrong post id' do
      before do
        @post = create :post, :with_user_statistics_evaluations, id: 10_000
      end

      it 'returns exception' do
        result = @create_evaluation.call
        expected_class = PostWithGivenIdDoesntExist
        expect(result).to be_instance_of(expected_class)
      end

      it 'returns exception with correct message' do
        result = @create_evaluation.call
        expected_message = 'Post with given id doesnt exist'
        expect(result.message).to eql(expected_message)
      end
    end
  end
end
