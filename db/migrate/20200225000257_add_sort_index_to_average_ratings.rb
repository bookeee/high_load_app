class AddSortIndexToAverageRatings < ActiveRecord::Migration[5.2]
  def change
    add_index :ratings, :average, order: { average: :desc }
  end
end
