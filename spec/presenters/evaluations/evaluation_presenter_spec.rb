# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'EvaluationPresenterSpec' do
  before do
    post = create :post, :with_user_statistics_evaluations_ratings
    @object = post.evaluations.last
    @presenter = Evaluations::EvaluationPresenter.new(@object)
  end

  describe '#as_json' do
    it 'returns correct data structure' do
      allow(@presenter).to receive(:current_avg_rating).and_return('2')
      result = @presenter.as_json
      expected_result = { current_avg_rating: '2' }
      expect(result).to eql(expected_result)
    end
  end

  describe '#current_avg_rating' do
    it 'returns formatted avg of rating' do
      result = @presenter.send(:current_avg_rating)
      expected_result = '444.0'
      expect(result).to eql(expected_result)
    end
  end
end
