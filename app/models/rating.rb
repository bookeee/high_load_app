# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :statistics

  validates_presence_of :average, :est_amount, :values_sum, :last_est_time, :last_est_id

  def formatted_avg
    average.to_s
  end
end
