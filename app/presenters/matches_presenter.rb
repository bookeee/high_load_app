# frozen_string_literal: true

class MatchesPresenter < Presenter
  def as_json(*)
    [match]
  end

  private

  def match
    @object.map { |match| MatchPresenter.new(match) }
  end
end
