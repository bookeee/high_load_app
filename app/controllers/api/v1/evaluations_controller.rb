# frozen_string_literal: true

module Api
  module V1
    class EvaluationsController < ApplicationController
      def do
        @evaluation = Services::Evaluations::Create.new(evaluation_params, request.env[:timestamp]).call

        if @evaluation
          render json: EvaluationPresenter.new(@evaluation), status: :created
        else
          render_error_response(@evaluation.errors.messages, 422)
        end
      end

      private

      def evaluation_params
        params.require(:evaluation).permit(:post_id, :value)
      end
    end
  end
end
