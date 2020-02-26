# frozen_string_literal: true

module Services
  module Posts
    class Top
      WHITELISTED_AMOUNT = (1..200_000).freeze
      SMALL_AMOUNT = 10000

      def initialize(amount)
        @amount = amount.to_i
      end

      def call
        validate_amount
        top_posts
      end

      private

      def validate_amount
        if WHITELISTED_AMOUNT.include?(@amount)
          # do nothing
        else
          raise WrongPostsAmount
        end
      end

      def top_ratings
        Rating.top(@amount)
      end

      def top_posts
        if @amount <= SMALL_AMOUNT
          query_for_small_amount
        else
          query_for_big_amount
        end
      end

      def query_for_small_amount
        Post.where(id: posts_ids)
      end

      def query_for_big_amount
        Queries::Posts::TopPostsQuery.new(@amount, posts_ids).call
      end

      def posts_ids
        top_ratings.map(&:last_est_id)
      end
    end
  end
end
