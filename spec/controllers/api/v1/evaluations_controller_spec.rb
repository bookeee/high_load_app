# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EvaluationsController, type: :controller do
  describe 'POST #do' do
    context 'with correct params' do
      let!(:new_post) { create(:post, :with_user_statistics, id: 1) }
      let(:evaluation_params) { { evaluation: { post_id: 1, value: 4 } } }

      before do
        request.env[:timestamp] = Time.zone.now
      end

      it 'creates new evaluation' do
        expect { post :do, params: evaluation_params, format: :json }.to change(Evaluation, :count).by(1)
      end

      it 'creates new rating' do
        expect { post :do, params: evaluation_params, format: :json }.to change(Rating, :count).by(1)
      end

      it 'returns code 200' do
        post :do, params: evaluation_params, format: :json
        code = JSON.parse(response.body)['code']
        expect(code).to eq 200
        expect(response.code).to eq '200'
      end

      it 'returns evaluation with specific fields' do
        post :do, params: evaluation_params, format: :json
        evaluation = JSON.parse(response.body)['evaluation']
        expected_result = { 'current_avg_rating' => '4.0' }
        expect(evaluation).to eql(expected_result)
      end
    end

    context 'with incorrect params' do
      let!(:new_post) { create(:post, :with_user_statistics, id: 1) }
      let(:evaluation_params) { { evaluation: { value: 4 } } }

      before do
        request.env[:timestamp] = Time.zone.now
      end

      it 'does not create new evaluation' do
        expect { post :do, params: evaluation_params, format: :json }.not_to change(Evaluation, :count)
      end

      it 'does not create new rating' do
        expect { post :do, params: evaluation_params, format: :json }.not_to change(Rating, :count)
      end

      it 'returns code 422' do
        post :do, params: evaluation_params, format: :json
        code = JSON.parse(response.body)['code']
        expect(code).to eq 422
        expect(response.code).to eq '422'
      end

      it 'returns text of the error' do
        post :do, params: evaluation_params, format: :json
        json = JSON.parse(response.body)
        expect(json['errors']).to be
      end
    end
  end
end
