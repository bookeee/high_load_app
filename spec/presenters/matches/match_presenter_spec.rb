# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'MatchPresenterSpec' do
  before do
    match = create :match
    @presenter = Matches::MatchPresenter.new(match)
  end

  describe '#as_json' do
    it 'returns correct data structure' do
      ip = '192.168.0.1'
      logins = %w[login1 login2]
      allow(@presenter).to receive(:ip).and_return(ip)
      allow(@presenter).to receive(:logins).and_return(logins)
      result = @presenter.as_json
      expected_result = { ip: '192.168.0.1', logins: %w[login1 login2] }
      expect(result).to eql(expected_result)
    end
  end

  describe '#ip' do
    it 'returns correct ip' do
      result = @presenter.send(:ip)
      expected_result = '192.168.0.12'
      expect(result).to eql(expected_result)
    end
  end

  describe '#logins' do
    it 'returns correct logins' do
      result = @presenter.send(:logins)
      expected_result = %w[login_one login_two login_three]
      expect(result).to eql(expected_result)
    end
  end
end
