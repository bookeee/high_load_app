# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create' do
  let(:login) { 'test_login' }

  before do
    @create_user = Services::Personas::Users::Create.new(login)
  end

  describe '#initialize' do
    it 'initializes correct instance' do
      expected_login = login
      expect(@create_user.instance_variable_get(:@login)).to eq(expected_login)
    end
  end

  describe '#call' do
    it 'calls create_user method' do
      allow(@create_user).to receive(:create_user)
      @create_user.call
      expect(@create_user).to have_received(:create_user)
    end
  end

  describe '#create_user' do
    context 'when we have user with same login' do
      before do
        login = 'test_login'
        @user = create :user, login: login
      end

      it 'finds user' do
        result = @create_user.send(:create_user)
        expected_class = Persona::User
        expect(result).to be_instance_of(expected_class)
        expect(result.id).to eql(@user.id)
      end
    end

    context "when we don't have user with same login" do
      it 'creates new user' do
        result = @create_user.send(:create_user)
        expected_class = Persona::User
        expect(result).to be_instance_of(expected_class)
      end
    end
  end
end
