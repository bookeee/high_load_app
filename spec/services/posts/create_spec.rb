# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create' do
  let(:args) { { title: 'post title', content: 'post content', login: 'test_login', ip: '192.168.0.22' } }

  before do
    @create_post = Services::Posts::Create.new(args)
  end

  describe '#initialize' do
    it 'initializes correct instance' do
      expected_title = 'post title'
      expect(@create_post.instance_variable_get(:@title)).to eq(expected_title)

      expected_content = 'post content'
      expect(@create_post.instance_variable_get(:@content)).to eq(expected_content)

      expected_login = 'test_login'
      expect(@create_post.instance_variable_get(:@login)).to eq(expected_login)

      expected_ip = '192.168.0.22'
      expect(@create_post.instance_variable_get(:@ip)).to eq(expected_ip)
    end
  end

  describe '#create_user' do
    it 'uses Services::Personas::Users::Create service' do
      service = Services::Personas::Users::Create
      login = @create_post.instance_variable_get(:@login)
      instance = double('create')
      allow(service).to receive(:new).with(login).and_return(instance)
      allow(instance).to receive(:call).and_return([])

      @create_post.send(:create_user)

      expect(service).to have_received(:new).with(login)
      expect(instance).to have_received(:call)
    end
  end

  describe '#create_session' do
    context 'when @user is present' do
      before do
        @user = create :user
      end

      it 'creates session for that user' do
        @create_post.send(:create_session)
        result = @user.sessions.count
        expected_result = 1
        expect(result).to eql(expected_result)
      end
    end

    context 'when @user is not present' do
      it 'creates session without a user' do
        session = @create_post.send(:create_session)
        result = session.users.count
        expected_result = 0
        expect(result).to eql(expected_result)
      end
    end
  end

  describe '#create_match' do
    it 'uses Services::Matches::Create service' do
      service = Services::Matches::Create
      ip = @create_post.instance_variable_get(:@ip)
      user = @create_post.instance_variable_get(:@user)

      instance = double('create')
      allow(service).to receive(:new).with(ip, user).and_return(instance)
      allow(instance).to receive(:call).and_return([])

      @create_post.send(:create_match)

      expect(service).to have_received(:new).with(ip, user)
      expect(instance).to have_received(:call)
    end
  end

  describe '#create_post' do
    it 'creates post for user' do
      user = create :user
      @create_post.instance_variable_set(:@user, user)

      result = @create_post.send(:create_post)
      expected_result = user

      expect(result.user).to eql(expected_result)
    end
  end

  describe '#create_statistics' do
    it 'creates statistics for post' do
      post = create :post, :with_user
      @create_post.instance_variable_set(:@post, post)

      result = @create_post.send(:create_statistics)
      expected_result = post

      expect(result.post).to eql(expected_result)
    end
  end

  describe '#call' do
    context 'when we have login and ip' do
      before do
        user = create :user, :with_post
        @create_post.instance_variable_set(:@user, user)
        @create_post.instance_variable_set(:@post, user.posts.first)
      end

      it 'calls create_user' do
        allow(@create_post).to receive(:create_user)
        @create_post.call
        expect(@create_post).to have_received(:create_user)
      end

      it 'calls create_session' do
        allow(@create_post).to receive(:create_session)
        @create_post.call
        expect(@create_post).to have_received(:create_session)
      end

      it 'calls create_match' do
        allow(@create_post).to receive(:create_match)
        @create_post.call
        expect(@create_post).to have_received(:create_match)
      end

      it 'calls create_post' do
        allow(@create_post).to receive(:create_post)
        @create_post.call
        expect(@create_post).to have_received(:create_post)
      end

      it 'calls create_statistics' do
        allow(@create_post).to receive(:create_statistics)
        @create_post.call
        expect(@create_post).to have_received(:create_statistics)
      end

      it 'returns Post' do
        result = @create_post.call
        expected_class = Post
        expect(result).to be_instance_of(expected_class)
      end
    end
  end
end
