# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Serializable' do
  before do
    @test_class = Class.new
    @instance = @test_class.new
    @test_class.include(Serializable)
  end

  describe '#serialize' do
    it 'serializes given array' do
      array = [1, 2, 3, 4, 5]
      result = @instance.serialize(array)
      expected_result = '[1,2,3,4,5]'
      expect(result).to eql(expected_result)
    end
  end

  describe '#deserialize' do
    context 'when we have correct data' do
      it 'deserializes given string' do
        string = '[1,2,3,4,5]'
        result = @instance.deserialize(string)
        expected_result = [1, 2, 3, 4, 5]
        expect(result).to eql(expected_result)
      end
    end

    context 'when we have incorrect data' do
      it 'returns nil' do
        a = 1
        result = @instance.deserialize(a)
        expected_result = nil
        expect(result).to eql(expected_result)
      end
    end
  end
end
