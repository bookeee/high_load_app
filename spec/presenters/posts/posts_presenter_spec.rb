# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'PostsPresenterSpec' do
  before do
    @object = create_list :post, 5, :with_user_statistics_evaluations_ratings
    @presenter = Posts::PostsPresenter.new(@object)
  end

  describe '#as_json' do
    it 'returns correct data structure' do
      collection = [1, 2, 3, 4]
      allow(@presenter).to receive(:post).and_return(collection)
      result = @presenter.as_json
      expected_result = [[1, 2, 3, 4]]
      expect(result).to eql(expected_result)
    end
  end

  describe '#post' do
    it 'returns formatted avg of rating' do
      presenter = Posts::PostPresenter
      post_presenter = { object: 111 }
      allow(presenter).to receive(:new).and_return(post_presenter)
      result = @presenter.send(:post)
      expected_result = [{ object: 111 }, { object: 111 }, { object: 111 },
                         { object: 111 }, { object: 111 }]
      expect(result).to eql(expected_result)
    end
  end
end
