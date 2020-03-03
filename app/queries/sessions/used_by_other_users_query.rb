# frozen_string_literal: true

module Queries
  module Sessions
    class UsedByOtherUsersQuery
      NAME = 'used_by_another_user_query'

      def initialize(ip, user_id)
        @ip = ip
        @user_id = user_id
      end

      def call
        ActiveRecord::Base.connection.exec_query(sql, NAME, bindings)
      end

      private

      def sql
        "
        Select *
        FROM sessions_users as su
        WHERE su.user_id != $1 AND
        su.session_id IN ( SELECT s.id FROM Sessions as s WHERE s.ip = $2 );"
      end

      def bindings
        [[nil, @user_id], [nil, @ip]]
      end
    end
  end
end
