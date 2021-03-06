# frozen_string_literal: true

module Services
  module Evaluations
    class Create
      def initialize(args, request_timestamp)
        @post_id = args[:post_id]
        @value = args[:value]
        @request_timestamp = request_timestamp
      end

      def call
        ActiveRecord::Base.transaction do
          set_post
          if @post
            create_evaluation
            calculate_rating
          else
            raise PostWithGivenIdDoesntExist
          end
        end
        @evaluation
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error(e.record.errors)
        e
      rescue PostWithGivenIdDoesntExist => e
        Rails.logger.error(e.message)
        e
      end

      private

      def calculate_rating
        Services::Ratings::Create.new(@post, @evaluation, @request_timestamp).call
      end

      def create_evaluation
        @evaluation = @post.evaluations.create!(value: @value)
      end

      def set_post
        @post = Post.where(id: @post_id).first
      end
    end
  end
end
