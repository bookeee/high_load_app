# frozen_string_literal: true

class Evaluation < ApplicationRecord
  belongs_to :post

  validates :value, presence: true
  validates :value, inclusion: { in: 1..5 }

  scope :previous_by_request, ->(timestamp) { where('created_at <= ?', timestamp) }

  def rating
    Rating.where(last_est_id: id).first
  end
end
