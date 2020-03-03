# frozen_string_literal: true

class Rating < ApplicationRecord
  belongs_to :statistics

  validates :average, :est_amount, :values_sum, :last_est_time, :last_est_id, presence: true

  scope :top, ->(amount) { order('average DESC').limit(amount) }

  def formatted_avg
    average.to_s
  end
end
