# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EvaluationsController, type: :routing do
  describe 'routing' do
    it 'routes to #do' do
      expect(post: 'api/v1/evaluations').to route_to('api/v1/evaluations#do')
    end
  end
end
