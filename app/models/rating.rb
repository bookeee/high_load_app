class Rating < ApplicationRecord

  belongs_to :statistics

  validates_presence_of :average, :est_amount, :values_sum, :last_est_id

end