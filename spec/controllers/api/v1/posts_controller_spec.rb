# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  describe 'POST #create' do
    context 'with correct params' do
      let(:post_params) { { title: 'test_post_title', content: 'test content', ip: '222.444.111.999', login: 'test_login' } }

      it 'creates new post' do
        expect { post :create, params: { post: post_params }, format: :json }.to change(Post, :count).by(1)
      end

      it 'creates new session' do
        expect { post :create, params: { post: post_params }, format: :json }.to change(Persona::Session, :count).by(1)
      end

      it 'creates new user' do
        expect { post :create, params: { post: post_params }, format: :json }.to change(Persona::User, :count).by(1)
      end

      it 'creates new statistics' do
        expect { post :create, params: { post: post_params }, format: :json }.to change(Statistics, :count).by(1)
      end

      it 'returns code 200' do
        post :create, params: { post: post_params }, format: :json
        code = JSON.parse(response.body)['code']
        expect(code).to eq 200
        expect(response.code).to eq '200'
      end

      it 'returns post with specific fields' do
        post :create, params: { post: post_params }, format: :json
        post = JSON.parse(response.body)['post']
        expected_result = { 'content' => 'test content', 'title' => 'test_post_title' }
        expect(post).to eql(expected_result)
      end
    end

    context 'with incorrect params' do
      let(:post_params) { { content: 'test content', ip: '222.444.111.999', login: 'test_login' } }

      it 'does not create new post' do
        expect { post :create, params: { post: post_params }, format: :json }.not_to change(Post, :count)
      end

      it 'does not create new session' do
        expect { post :create, params: { post: post_params }, format: :json }.not_to change(Persona::Session, :count)
      end

      it 'does not create new user' do
        expect { post :create, params: { post: post_params }, format: :json }.not_to change(Persona::User, :count)
      end

      it 'does not create new statistics' do
        expect { post :create, params: { post: post_params }, format: :json }.not_to change(Statistics, :count)
      end

      it 'returns code 422' do
        post :create, params: { post: post_params }, format: :json
        code = JSON.parse(response.body)['code']
        expect(code).to eq 422
        expect(response.code).to eq '422'
      end

      it 'returns text of the error' do
        post :create, params: { post: post_params }, format: :json
        json = JSON.parse(response.body)
        expect(json['errors']).to be
      end
    end
  end

  describe 'GET #top' do
    let!(:post_params) { { posts_amount: 3 } }

    before do
      create_list :post, 100, :with_user_statistics_evaluations_ratings
    end

    context 'with correct params' do
      it 'returns code 200' do
        get :top, params: post_params, format: :json
        code = JSON.parse(response.body)['code']
        expect(code).to eq 200
        expect(response.code).to eq '200'
      end

      it 'returns correct post array' do
        get :top, params: post_params, format: :json
        expected_result = [[{ 'content' => 'test content', 'title' => 'test_title' },
                            { 'content' => 'test content', 'title' => 'test_title' },
                            { 'content' => 'test content', 'title' => 'test_title' }]]
        result = JSON.parse(response.body)['posts']
        expect(result).to eql(expected_result)
      end
    end

    context 'with incorrect params' do
      it 'returns code 422' do
        params = { posts_amount: -2 }
        get :top, params: params, format: :json
        code = JSON.parse(response.body)['code']
        expect(code).to eq 422
        expect(response.code).to eq '422'
      end

      it 'returns errors' do
        get :top, params: { posts_amount: -2 }, format: :json
        json = JSON.parse(response.body)
        expect(json['errors']).to be
      end
    end
  end
end
