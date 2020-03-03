# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user, class_name: 'Persona::User'
  has_many :evaluations
  has_one :statistics

  validates :title, :content, presence: true
end
