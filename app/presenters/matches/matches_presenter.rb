# frozen_string_literal: true

module Matches
  class MatchesPresenter < Presenter
    def as_json(*)
      [match]
    end

    private

    def match
      @object.map { |match| MatchPresenter.new(match) }
    end
  end
end
