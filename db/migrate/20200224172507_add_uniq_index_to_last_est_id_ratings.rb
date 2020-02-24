class AddUniqIndexToLastEstIdRatings < ActiveRecord::Migration[5.2]
  def change
    add_index :ratings, :last_est_id, unique: true
  end
end