# frozen_string_literal: true

class Evaluation < ApplicationRecord
  belongs_to :post

  validates_presence_of :value
  validates_inclusion_of :value, in: 1..5

  scope :previous_by_request, ->(timestamp) { where('created_at <= ?', timestamp) }

  def rating
    Rating.where(last_est_id: id).first
  end
end
