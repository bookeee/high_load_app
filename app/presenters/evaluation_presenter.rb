# frozen_string_literal: true

class EvaluationPresenter < Presenter
  def as_json(*)
    {
      current_avg_rating: current_avg_rating
    }
  end

  private

  def current_avg_rating
    @object.rating.formatted_avg
  end
end
