class Evaluation < ApplicationRecord

  validates_inclusion_of :value, :in => 1..5

end
