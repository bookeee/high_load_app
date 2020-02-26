# frozen_string_literal: true

module Api
  module V1
    class MatchesController < ApplicationController
      def index
        @matches = Match.all

        render json: MatchesPresenter.new(@matches)
      end
    end
  end
end
