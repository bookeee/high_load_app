# frozen_string_literal: true

module Api
  module V1
    class EvaluationsController < ApplicationController
      def do
        @result = Services::Evaluations::Create.new(evaluation_params, request.env[:timestamp]).call

        if @result.is_a?(Evaluation)
          render json: EvaluationPresenter.new(@result), status: :created
        else
          render_error_response(@result, 422)
        end
      end

      private

      def evaluation_params
        params.require(:evaluation).permit(:post_id, :value)
      end
    end
  end
end
