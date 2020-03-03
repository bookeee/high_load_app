# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UsedByOtherUsersQuery' do
  let(:ip) { '192.168.1.1' }
  let(:user_id) { 1 }

  before do
    @used_by_other_users_query = Queries::Sessions::UsedByOtherUsersQuery.new(ip, user_id)
  end

  describe '#initialize' do
    it 'initializes correct instance' do
      expected_result = '192.168.1.1'
      expect(@used_by_other_users_query.instance_variable_get(:@ip)).to eq(expected_result)

      expected_result = 1
      expect(@used_by_other_users_query.instance_variable_get(:@user_id)).to eq(expected_result)
    end
  end

  describe '#call' do
    it 'executes given sql' do
      sql = 'SELECT * FROM sessions'
      name = 'used_by_another_user_query'
      bindings = [[nil, user_id], [nil, ip]]
      connection = double('Connection')

      allow(@used_by_other_users_query).to receive(:sql).and_return(sql)
      expect(ActiveRecord::Base).to receive(:connection) { connection }
      expect(connection).to receive(:exec_query).with(sql, name, bindings)
      @used_by_other_users_query.call
    end
  end

  describe '#sql' do
    it 'creates correct sql query' do
      expected_result = "\n        Select *\n        FROM sessions_users as su\n"\
                       "        WHERE su.user_id != $1 AND\n        "\
                       'su.session_id IN ( SELECT s.id FROM Sessions as s WHERE s.ip = $2 );'
      result = @used_by_other_users_query.send(:sql)
      expect(result).to eql(expected_result)
    end
  end

  describe '#bindings' do
    it 'returns correct data structure' do
      expected_result = [[nil, user_id], [nil, ip]]
      result = @used_by_other_users_query.send(:bindings)
      expect(result).to eql(expected_result)
    end
  end
end
