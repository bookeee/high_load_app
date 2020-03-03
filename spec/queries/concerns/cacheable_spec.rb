# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cacheable' do
  before do
    @test_class = Class.new
    @test_class.send(:define_method, 'amount') { nil }
    @instance = @test_class.new
    @test_class.include(Cacheable)
    $redis = MockRedis.new
  end

  describe '#amount_can_be_cached?' do
    it 'compares amount and limit' do
      query = 'test'
      allow(@instance).to receive(:amount).and_return(5)
      allow(@instance).to receive(:limit).with(query).and_return(6)
      result = @instance.amount_can_be_cached?(query)
      expected_result = true
      expect(result).to eql(expected_result)
    end
  end

  describe '#limit' do
    it 'uses Services::Settings::Cachings::Get service' do
      service = Services::Settings::Cachings::Get
      query = 'test_query'
      filed = 'limit'
      allow(service).to receive(:call).with(query, filed)
      @instance.limit(query)
      expect(service).to have_received(:call).with(query, filed)
    end
  end

  describe '#delete_' do
    it 'deletes key from redis' do
      key = 'test key'
      value = 'test value'
      $redis.set(key, value)
      @instance.delete_(key)
      result = $redis.keys(key)
      expected_result = []
      expect(result).to eql(expected_result)
    end
  end

  describe '#create_list' do
    it 'saves list to redis' do
      key = 'test key'
      value = [1, 2, 3, 4, 5]
      ends_at = 5
      @instance.create_list(key, value)
      result = $redis.lrange(key, 0, ends_at)
      expected_result = %w[5 4 3 2 1]
      expect(result).to eql(expected_result)
    end
  end

  describe '#set_expiration_time' do
    before do
      Timecop.freeze DateTime.current
    end

    after { Timecop.return }

    it 'sets expiration time for key' do
      key = 'test key'
      value = [1, 2, 3, 4, 5]
      ends_at = 5
      expiration_time = 30
      $redis.lpush(key, value)
      allow(@instance).to receive(:caching_time).with(key).and_return(expiration_time)
      @instance.set_expiration_time(key)

      result = $redis.lrange(key, 0, ends_at)
      expected_result = %w[5 4 3 2 1]
      expect(result).to eql(expected_result)

      Timecop.travel(DateTime.current + 40.seconds)
      result = $redis.lrange(key, 0, ends_at)
      expected_result = []
      expect(result).to eql(expected_result)
    end
  end

  describe '#caching_time' do
    it 'uses Services::Settings::Cachings::Get service' do
      service = Services::Settings::Cachings::Get
      query = 'test_query'
      filed = 'caching_time'
      allow(service).to receive(:call).with(query, filed)
      @instance.caching_time(query)
      expect(service).to have_received(:call).with(query, filed)
    end
  end

  describe '#get_list' do
    it 'gets list from redis' do
      key = 'test key'
      start_at = 0
      ends_at = 5
      value = [1, 2, 3, 4, 5]
      $redis.lpush(key, value)
      result = $redis.lrange(key, 0, ends_at)
      expected_result = %w[5 4 3 2 1]
      expect(result).to eql(expected_result)
    end
  end

  describe '#key_exists?' do
    it 'checks if key exists in redis' do
      key = 'test key test'
      value = [1, 2, 3, 4, 5]
      $redis.lpush(key, value)
      result = @instance.key_exists?(key)
      expected_result = true
      expect(result).to eql(expected_result)
    end
  end
end
