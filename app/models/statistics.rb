# frozen_string_literal: true

class Statistics < ApplicationRecord
  belongs_to :post
  has_many :ratings
end
