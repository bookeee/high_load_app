class AddStatisticsIdToRatings < ActiveRecord::Migration[5.2]
  def change
    add_column :ratings, :statistics_id, :integer
  end
end
