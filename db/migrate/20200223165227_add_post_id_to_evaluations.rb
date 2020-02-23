class AddPostIdToEvaluations < ActiveRecord::Migration[5.2]
  def change
    add_column :evaluations, :post_id, :integer
  end
end
