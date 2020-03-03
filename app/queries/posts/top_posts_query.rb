# frozen_string_literal: true

module Queries
  module Posts
    class TopPostsQuery
      KEY_NAME = 'top_posts_query'

      include Cacheable
      include Serializable

      attr_reader :amount

      def initialize(amount, posts_ids)
        @amount = amount
        @posts_ids = posts_ids
      end

      def call
        if from_cache?
          get_records_from_cache
        else
          set_key
          get_records_from_cache
        end
      end

      private

      def set_key
        delete_(KEY_NAME)
        posts = serialize(records_array)
        create_list(KEY_NAME, posts)
        set_expiration_time(KEY_NAME)
      end

      def get_records_from_cache
        deserialize(get_key)
      end

      def get_key
        get_list(KEY_NAME, 0, ends_at)
      end

      def ends_at
        amount - 1
      end

      def amount_cached?
        list_count >= amount
      end

      def list_count
        deserialize(get_key).count
      end

      def sql
        <<-SQL
          SELECT *
          FROM   unnest('{#{formatted_ids}}'::int[]) "id"
          JOIN   posts "Post" USING ("id");
        SQL
      end

      def records_array
        perform_query.to_a
      end

      def perform_query
        ActiveRecord::Base.connection.execute(sql)
      end

      def formatted_ids
        @posts_ids.join(',')
      end

      def from_cache?
        key_exists?(KEY_NAME) && amount_cached? && amount_can_be_cached?(KEY_NAME)
      end
    end
  end
end
