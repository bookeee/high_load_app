# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MatchesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/v1/matches').to route_to('api/v1/matches#index')
    end
  end
end
