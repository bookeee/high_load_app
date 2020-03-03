# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'PostPresenterSpec' do
  before do
    @object = create :post, :with_user_statistics_evaluations_ratings
    @presenter = Posts::PostPresenter.new(@object)
  end

  describe '#as_json' do
    it 'returns correct data structure' do
      title = 'test title'
      allow(@presenter).to receive(:title).and_return(title)
      content = 'test content'
      allow(@presenter).to receive(:content).and_return(content)
      result = @presenter.as_json
      expected_result = { content: 'test content', title: 'test title' }
      expect(result).to eql(expected_result)
    end
  end

  describe '#title' do
    it 'returns formatted avg of rating' do
      result = @presenter.send(:title)
      expected_result = 'test_title'
      expect(result).to eql(expected_result)
    end
  end

  describe '#content' do
    it 'returns formatted avg of rating' do
      result = @presenter.send(:content)
      expected_result = 'test content'
      expect(result).to eql(expected_result)
    end
  end
end
