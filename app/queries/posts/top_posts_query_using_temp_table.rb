# alternative approach to top_posts query
# not clean design, only for testing purposes
# frozen_string_literal: true

module Queries
  module Posts
    class TopPostsQueryUsingTempTable

      def initialize(posts_ids)
        @posts_ids = (1..1000000).to_a
      end

      def call
        ActiveRecord::Base.transaction do
          create_table
          fill_temp_table
          @result = get_records
        end
        @result
      end

      private

      def create_table
        query = <<-SQL
                CREATE TEMP TABLE post_ids_temp_table(id bigserial NOT NULL PRIMARY KEY) ON COMMIT DROP;
        SQL
        result = ActiveRecord::Base.connection.execute(query)
      end

      def fill_temp_table
        query = <<-SQL
                INSERT INTO post_ids_temp_table(id)
                values(unnest(ARRAY[#{@posts_ids}]))
        SQL
        result = ActiveRecord::Base.connection.execute(query)
      end

      def get_records
        query = <<-SQL
         EXPLAIN ANALYZE SELECT * FROM posts p INNER JOIN post_ids_temp_table t ON p.id = t.id;
        SQL
        result = ActiveRecord::Base.connection.execute(query)
        result
      end

    end
  end
end
