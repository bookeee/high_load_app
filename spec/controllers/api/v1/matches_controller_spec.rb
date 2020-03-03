# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MatchesController, type: :controller do
  describe 'GET #index' do
    context 'with correct params' do
      before do
        create_list :match, 5
      end

      it 'finds all evaluations' do
        get :index, format: :json
        expected_result = { 'code' => 200,
                            'matches' =>
                               [[{ 'ip' => '192.168.0.1', 'logins' => %w[login_one login_two login_three] },
                                 { 'ip' => '192.168.0.2', 'logins' => %w[login_one login_two login_three] },
                                 { 'ip' => '192.168.0.3', 'logins' => %w[login_one login_two login_three] },
                                 { 'ip' => '192.168.0.4', 'logins' => %w[login_one login_two login_three] },
                                 { 'ip' => '192.168.0.5', 'logins' => %w[login_one login_two login_three] }]] }
        result = JSON.parse(response.body)
        expect(result).to eql(expected_result)
      end

      it 'returns code 200' do
        get :index, format: :json
        code = JSON.parse(response.body)['code']
        expect(code).to eq 200
        expect(response.code).to eq '200'
      end
    end
  end
end
