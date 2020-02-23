class AddPostIdToStatistics < ActiveRecord::Migration[5.2]
  def change
    add_column :statistics, :post_id, :integer
  end
end
