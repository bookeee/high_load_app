# frozen_string_literal: true

module Services
  module Ratings
    class Create
      def initialize(post, current_evaluation, request_timestamp)
        @post = post
        @current_evaluation = current_evaluation
        @request_timestamp = request_timestamp
      end

      def call
        create
      end

      private

      def create
        @post.statistics.ratings.create!(average: average, est_amount: est_amount,
                                         values_sum: values_sum, last_est_time: last_est_time,
                                         last_est_id: last_est_id)
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error(e.record.errors)
      end

      def last_est_id
        @current_evaluation.id
      end

      def est_amount
        @est_amount ||= evaluations.length
      end

      def last_est_time
        @request_timestamp
      end

      def evaluations
        @evaluations ||= (previous_evaluations << @current_evaluation)
      end

      def previous_evaluations
        @evaluations = @post.evaluations.previous_by_request(@request_timestamp).to_a
      end

      def values_sum
        @sum ||= evaluations.sum { |x| x[:value] }
      end

      def average
        values_sum.to_d / est_amount
      end
    end
  end
end
