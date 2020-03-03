# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: 'api/v1/posts').to route_to('api/v1/posts#create')
    end

    it 'routes to #top' do
      expect(get: 'api/v1/top_posts/5').to route_to('api/v1/posts#top', 'posts_amount' => '5')
    end
  end
end
