class Evaluation < ApplicationRecord

  belongs_to :post

  validates_presence_of :value
  validates_inclusion_of :value, :in => 1..5

end
