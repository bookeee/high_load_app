# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Top' do
  let(:amount) { '100' }

  before do
    @top_posts = Services::Posts::Top.new(amount)
  end

  describe '#initialize' do
    it 'initializes correct instance' do
      expected_amount = 100
      expect(@top_posts.instance_variable_get(:@amount)).to eq(expected_amount)
    end
  end

  describe '#call' do
    before do
      allow(@top_posts).to receive(:validate_amount).and_return(true)
      allow(@top_posts).to receive(:top_posts).and_return(true)
    end

    it 'calls validate_amount' do
      @top_posts.call
      expect(@top_posts).to have_received(:validate_amount)
    end

    it 'calls top_posts' do
      @top_posts.call
      expect(@top_posts).to have_received(:top_posts)
    end
  end

  describe '#validate_amount' do
    context 'when amount is present in whitelisted amount' do
      before do
        @amount = 100_000
      end

      it 'returns nil' do
        @top_posts.instance_variable_set(:@amount, @amount)
        result = @top_posts.send(:validate_amount)

        expected_result = nil
        expect(result).to eql(expected_result)
      end
    end

    context 'when amount is nil present in whitelisted amount' do
      before do
        @amount = 10_000_000_000_000_000_000
      end

      it 'raises WrongPostsAmount exception' do
        @top_posts.instance_variable_set(:@amount, @amount)
        expect { @top_posts.send(:validate_amount) }.to raise_error(WrongPostsAmount)
      end
    end
  end

  it 'calls Queries::Sessions::UsedByOtherUsersQuery.new(ip, user_id).call.any?' do
    ip = '111.222.333.444'
    user_id = 1
    instance = double('used_by_other_users_query')
    instances = double('active_record_relation')
    service = Queries::Sessions::UsedByOtherUsersQuery

    allow(service).to receive(:new).and_return(instance)
    instance.stub(:call).and_return(instances)
    instances.stub(:any?).and_return(true)

    Persona::Session.used_by_another_user?(ip, user_id)

    expect(service).to have_received(:new).with(ip, user_id)
    expect(instance).to have_received(:call)
    expect(instances).to have_received(:any?)
  end

  describe '#top_ratings' do
    it 'calls Rating#top method' do
      amount = 5
      @top_posts.instance_variable_set(:@amount, amount)
      model = Rating
      allow(model).to receive(:top).with(amount)
      @top_posts.send(:top_ratings)

      expect(model).to have_received(:top).with(amount)
    end
  end

  describe '#top_posts' do
    context 'when given amount is small' do
      it 'calls query_for_small_amount' do
        amount = 5
        @top_posts.instance_variable_set(:@amount, amount)
        allow(@top_posts).to receive(:query_for_small_amount)
        @top_posts.send(:top_posts)

        expect(@top_posts).to have_received(:query_for_small_amount)
      end
    end

    context 'when given amount is bigger then SMALL_AMOUNT' do
      it 'calls query_for_big_amount' do
        amount = 10_000_000_000_000
        @top_posts.instance_variable_set(:@amount, amount)
        allow(@top_posts).to receive(:query_for_big_amount)
        @top_posts.send(:top_posts)

        expect(@top_posts).to have_received(:query_for_big_amount)
      end
    end
  end

  describe '#query_for_small_amount' do
    context 'when we have posts with posts_ids' do
      before do
        @posts = create_list :post, 5, :with_user_statistics_evaluations_ratings
      end

      it 'finds posts with specified posts_ids' do
        result = @top_posts.send(:query_for_small_amount)

        expected_result = @posts.count
        expect(result.count).to eql(expected_result)
      end
    end

    context "when we don't have posts with posts_ids" do
      it 'returns 0 records' do
        result = @top_posts.send(:query_for_small_amount)
        expected_result = 0
        expect(result.count).to eql(expected_result)
      end
    end
  end

  describe '#query_for_big_amount' do
    it 'uses Queries::Posts::TopPostsQuery service' do
      service = Queries::Posts::TopPostsQuery
      amount = @top_posts.instance_variable_get(:@amount)
      posts_ids = [1, 2, 3, 4]
      allow(@top_posts).to receive(:posts_ids).and_return(posts_ids)

      instance = double('top_posts_query')
      allow(service).to receive(:new).with(amount, posts_ids).and_return(instance)
      allow(instance).to receive(:call).and_return([])

      @top_posts.send(:query_for_big_amount)

      expect(service).to have_received(:new).with(amount, posts_ids)
      expect(instance).to have_received(:call)
    end
  end

  describe '#evaluations' do
    context 'when we have posts and evaluations' do
      before do
        @posts = create_list :post, 5, :with_user_statistics_evaluations_ratings
        @evaluations = Evaluation.last(5)
      end

      it 'finds evaluations' do
        result = @top_posts.send(:evaluations)
        expected_result = @evaluations
        expect(result).to match_array(expected_result)
      end
    end

    context "when we don't have posts and evaluations" do
      it 'returns 0 records' do
        result = @top_posts.send(:posts_ids)
        expected_result = []
        expect(result).to eql(expected_result)
      end
    end
  end

  describe '#evaluations_ids' do
    context 'when we have posts and evaluations' do
      before do
        @posts = create_list :post, 5, :with_user_statistics_evaluations_ratings
        @ratings = Rating.last(5)
      end

      it 'gets array with last_est_id' do
        allow(@top_posts).to receive(:top_ratings).and_return(@ratings)
        result = @top_posts.send(:evaluations_ids)
        expected_result = @ratings.map(&:last_est_id)
        expect(result).to match_array(expected_result)
      end
    end

    context "when we don't have posts and evaluations" do
      it 'returns 0 records' do
        allow(@top_posts).to receive(:top_ratings).and_return([])
        result = @top_posts.send(:evaluations_ids)
        expected_result = []
        expect(result).to eql(expected_result)
      end
    end
  end

  describe '#posts_ids' do
    context 'when we have posts with posts_ids' do
      before do
        @posts = create_list :post, 5, :with_user_statistics_evaluations_ratings
      end

      it 'finds posts with specified posts_ids' do
        result = @top_posts.send(:posts_ids)
        expected_result = @posts.map(&:id)
        expect(result).to match_array(expected_result)
      end
    end

    context "when we don't have posts with posts_ids" do
      it 'returns 0 records' do
        result = @top_posts.send(:posts_ids)
        expected_result = []
        expect(result).to eql(expected_result)
      end
    end
  end
end
