class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.decimal :average
      t.integer :est_amount
      t.integer :values_sum
      t.column :last_est_time, 'timestamp with time zone'
      t.integer :last_est_id
      t.index ["last_est_id"], name: "index_ratings_on_last_est_id", using: :btree
      t.timestamps
    end
  end
end
