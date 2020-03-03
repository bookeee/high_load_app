# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TopPostsQuery' do
  let(:amount) { 10 }
  let(:posts_ids) { [1, 2, 3, 4, 5] }

  before do
    @top_posts_query = Queries::Posts::TopPostsQuery.new(amount, posts_ids)
    @caching = create :caching
  end

  describe 'class' do
    it 'includes Cacheable' do
      result = @top_posts_query.class.ancestors
      expected_result = Cacheable
      expect(result).to include(expected_result)
    end

    it 'includes Serializable' do
      result = @top_posts_query.class.ancestors
      expected_result = Serializable
      expect(result).to include(expected_result)
    end
  end

  describe '#initialize' do
    it 'initializes correct instance' do
      expected_result = 10
      expect(@top_posts_query.instance_variable_get(:@amount)).to eq(expected_result)

      expected_result = [1, 2, 3, 4, 5]
      expect(@top_posts_query.instance_variable_get(:@posts_ids)).to eq(expected_result)
    end
  end

  describe '#call' do
    context 'when from_cache? returns true' do
      it 'gets records from cache' do
        allow(@top_posts_query).to receive(:from_cache?).and_return(true)
        allow(@top_posts_query).to receive(:get_records_from_cache)
        @top_posts_query.call
        expect(@top_posts_query).to have_received(:get_records_from_cache)
      end
    end

    context 'when from_cache? returns false' do
      it 'sets key and get records from cache' do
        allow(@top_posts_query).to receive(:from_cache?).and_return(false)
        allow(@top_posts_query).to receive(:get_records_from_cache)
        allow(@top_posts_query).to receive(:set_key)
        @top_posts_query.call
        expect(@top_posts_query).to have_received(:set_key)
        expect(@top_posts_query).to have_received(:get_records_from_cache)
      end
    end
  end

  describe '#set_key' do
    it 'deletes key' do
      allow(@top_posts_query).to receive(:delete_)
      @top_posts_query.send(:set_key)
      expect(@top_posts_query).to have_received(:delete_)
    end

    it 'gets records_array' do
      allow(@top_posts_query).to receive(:records_array)
      @top_posts_query.send(:set_key)
      expect(@top_posts_query).to have_received(:records_array)
    end

    it 'creates list with posts' do
      allow(@top_posts_query).to receive(:create_list)
      @top_posts_query.send(:set_key)
      expect(@top_posts_query).to have_received(:create_list)
    end

    it 'sets expiration time for given key' do
      allow(@top_posts_query).to receive(:set_expiration_time)
      @top_posts_query.send(:set_key)
      expect(@top_posts_query).to have_received(:set_expiration_time)
    end
  end

  describe '#get_records_from_cache' do
    it 'deserializes given key' do
      key = 'sample key'
      allow(@top_posts_query).to receive(:get_key).and_return(key)
      allow(@top_posts_query).to receive(:deserialize)
      @top_posts_query.send(:get_records_from_cache)
      expect(@top_posts_query).to have_received(:deserialize).with(key)
    end
  end

  describe '#get_key' do
    it 'calls get_list' do
      key_name = 'top_posts_query'
      list_example = [1, 2, 3, 4]
      allow(@top_posts_query).to receive(:ends_at).and_return(1)
      allow(@top_posts_query).to receive(:get_list).and_return(list_example)
      @top_posts_query.send(:get_key)
      expect(@top_posts_query).to have_received(:get_list).with(key_name, 0, 1)
    end
  end

  describe '#ends_at' do
    it 'calculates index correctly' do
      expected_result = 1
      allow(@top_posts_query).to receive(:amount).and_return(2)
      result = @top_posts_query.send(:ends_at)
      expect(result).to eql(expected_result)
    end
  end

  describe '#amount_cached?' do
    it 'compares elements in list and given amount' do
      expected_result = true
      allow(@top_posts_query).to receive(:list_count).and_return(3)
      allow(@top_posts_query).to receive(:amount).and_return(2)
      result = @top_posts_query.send(:amount_cached?)
      expect(result).to eql(expected_result)
    end
  end

  describe '#list_count' do
    it 'deserializes given key' do
      key = Object.new
      allow(@top_posts_query).to receive(:get_key).and_return(key)
      list = [1, 2, 3, 5]
      allow(@top_posts_query).to receive(:deserialize).with(key).and_return(list)
      allow(list).to receive(:count)
      @top_posts_query.send(:list_count)

      expect(@top_posts_query).to have_received(:deserialize).with(key)
    end

    it 'counts deserialized result' do
      key = Object.new
      allow(@top_posts_query).to receive(:get_key).and_return(key)
      list = [1, 2, 3, 5]
      allow(@top_posts_query).to receive(:deserialize).with(key).and_return(list)
      allow(list).to receive(:count)
      @top_posts_query.send(:list_count)

      expect(list).to have_received(:count)
    end
  end

  describe '#sql' do
    it 'generates correct sql' do
      result = @top_posts_query.send(:sql)
      expected_result = "          SELECT *\n          "\
                        "FROM   unnest('{1,2,3,4,5}'::int[]) \"id\"\n          "\
                        "JOIN   posts \"Post\" USING (\"id\");\n"
      expect(result).to eql(expected_result)
    end
  end

  describe '#records_array' do
    it 'calls perform_query' do
      collection = [1, 2, 3, 4]
      allow(@top_posts_query).to receive(:perform_query).and_return(collection)
      @top_posts_query.send(:records_array)

      expect(@top_posts_query).to have_received(:perform_query)
    end

    it 'coverts collection to array' do
      collection = [1, 2, 3, 4]
      allow(@top_posts_query).to receive(:perform_query).and_return(collection)
      allow(collection).to receive(:to_a)
      @top_posts_query.send(:records_array)

      expect(collection).to have_received(:to_a)
    end
  end

  describe '#perform_query' do
    it 'executes given sql' do
      sql = 'SELECT * FROM posts'
      connection = double('Connection')

      allow(@top_posts_query).to receive(:sql).and_return(sql)
      expect(ActiveRecord::Base).to receive(:connection) { connection }
      expect(connection).to receive(:execute).with(sql)
      @top_posts_query.send(:perform_query)
    end
  end

  describe '#formatted_ids' do
    it 'returns formatted string' do
      expected_result = '1,2,3,4,5'
      result = @top_posts_query.send(:formatted_ids)
      expect(result).to eql(expected_result)
    end
  end
end
