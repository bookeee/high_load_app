# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'MatchesPresenterSpec' do
  before do
    matches = create_list :match, 5
    @presenter = Matches::MatchesPresenter.new(matches)
  end

  describe '#as_json' do
    it 'returns correct data structure' do
      collection = [1, 2, 3, 4]
      allow(@presenter).to receive(:match).and_return(collection)
      result = @presenter.as_json
      expected_result = [[1, 2, 3, 4]]
      expect(result).to eql(expected_result)
    end
  end

  describe '#match' do
    it 'returns collection in correct format' do
      presenter = Matches::MatchPresenter
      match_presenter = { object: 111 }
      allow(presenter).to receive(:new).and_return(match_presenter)
      result = @presenter.send(:match)
      expected_result = [{ object: 111 }, { object: 111 }, { object: 111 },
                         { object: 111 }, { object: 111 }]
      expect(result).to eql(expected_result)
    end
  end
end
