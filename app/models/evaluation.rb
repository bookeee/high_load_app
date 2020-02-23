class Evaluation < ApplicationRecord

  belongs_to :post

  validates_inclusion_of :value, :in => 1..5

end
