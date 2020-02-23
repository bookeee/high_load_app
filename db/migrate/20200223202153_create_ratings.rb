class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.decimal :average
      t.integer :est_amount
      t.integer :values_sum
      t.integer :last_est_id

      t.timestamps
    end
  end
end
