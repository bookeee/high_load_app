# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create' do
  let(:ip) { '192.168.0.1' }
  let(:user) { create :user, login: 'test_login' }

  before do
    @create_match = Services::Matches::Create.new(ip, user)
  end

  describe '#initialize' do
    it 'initializes correct instance' do
      expected_post_id = ip
      expect(@create_match.instance_variable_get(:@ip)).to eq(expected_post_id)

      expected_user = user
      expect(@create_match.instance_variable_get(:@user)).to eq(expected_user)
    end
  end

  describe '#create_match' do
    context 'when we have @match' do
      before do
        match = create :match
        @create_match.instance_variable_set(:@match, match)
      end

      it 'calls update method' do
        allow(@create_match).to receive(:update)
        @create_match.send(:create_match)

        expect(@create_match).to have_received(:update)
      end
    end

    context 'when we dont have @match' do
      it 'calls create_new method' do
        allow(@create_match).to receive(:create_new)
        @create_match.send(:create_match)

        expect(@create_match).to have_received(:create_new)
      end
    end
  end

  describe '#update' do
    context "when @match already have user's login" do
      before do
        logins = ['test_login']
        match = create :match, logins: logins
        @create_match.instance_variable_set(:@match, match)
      end

      it 'returns nil' do
        result = @create_match.send(:update)
        expected_result = nil
        expect(result).to eql(expected_result)
      end
    end

    context "when @match don't have user's login" do
      before do
        @logins = ['test_login_two']
        match = create :match, logins: @logins
        @create_match.instance_variable_set(:@match, match)
      end

      it 'adds new login to logins' do
        @create_match.send(:update)
        result = @create_match.instance_variable_get(:@match).logins
        expected_result = @logins << user.login
        expect(result).to eql(expected_result)
      end
    end
  end

  describe '#create_new' do
    context 'when we have correct parameters' do
      it 'returns Match instance' do
        result = @create_match.send(:create_new)
        expected_class = Match
        expect(result).to be_instance_of(expected_class)
      end
    end
  end

  describe '#set_match' do
    context 'when we have matches' do
      before do
        ip = '192.168.0.30'
        create :match, ip: ip
        @create_match.instance_variable_set(:@ip, ip)
      end

      it 'finds match by ip filed' do
        result = @create_match.send(:set_match)
        expected_class = Match
        expect(result).to be_instance_of(expected_class)
      end
    end

    context 'when we dont have matches' do
      before do
        ip = '192.168.0.30'
        @create_match.instance_variable_set(:@ip, ip)
      end

      it 'returns nil' do
        result = @create_match.send(:set_match)
        expected_result = nil
        expect(result).to eql(expected_result)
      end
    end
  end

  describe '#match_exists?' do
    it 'calls Persona::Session.used_by_another_user?(@ip, @user.id)' do
      model = Persona::Session
      allow(model).to receive(:used_by_another_user?)
      @create_match.send(:match_exists?)
      expect(model).to have_received(:used_by_another_user?).with(ip, user.id)
    end
  end

  describe '#call' do
    context 'when match exists' do
      it 'returns instance of Match class' do
        @create_match.stub(:match_exists?).and_return(true)
        result = @create_match.call
        result = @create_match.instance_variable_get(:@match)
        expected_result = Match
        expect(result).to be_instance_of(expected_result)
      end
    end

    context "when match doesn't exists" do
      it 'returns instance of Match class' do
        @create_match.stub(:match_exists?).and_return(false)
        result = @create_match.call
        result = @create_match.instance_variable_get(:@match)
        expected_result = nil
        expect(result).to eql(expected_result)
      end
    end
  end
end
