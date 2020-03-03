# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Get' do
  let(:post) { create :post, :with_user_statistics_evaluations_ratings }
  let(:current_evaluation) { create :evaluation, post: post }

  let(:caching) { create :caching }

  before do
    @caching = create :caching
  end

  describe 'self.call' do
    it 'calls public_send method with method name' do
      query = 'top_posts_query'
      setting_name = 'caching_time'
      service = Services::Settings::Cachings::Get
      service.instance_variable_set(:@settings, @caching)
      allow(@caching).to receive(:public_send).with('top_posts_caching_time')
      Services::Settings::Cachings::Get.call(query, setting_name)

      expect(@caching).to have_received(:public_send).with('top_posts_caching_time')
    end
  end

  describe 'self.settings' do
    it 'finds Caching' do
      Services::Settings::Cachings::Get
      result = Services::Settings::Cachings::Get.settings
      expected_class = Settings::Caching
      expect(result).to be_instance_of(expected_class)
    end
  end

  describe 'self.field' do
    it 'gets correct method name' do
      query = 'top_posts_query'
      setting_name = 'caching_time'
      expected_result = 'top_posts_caching_time'
      result = Services::Settings::Cachings::Get.field(query, setting_name)

      expect(result).to eql(expected_result)
    end
  end
end
