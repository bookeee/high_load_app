class CreateCachings < ActiveRecord::Migration[5.2]
  def change
    create_table :cachings do |t|
      t.integer :top_posts_caching_time
      t.integer :top_posts_limit

      t.timestamps
    end
  end
end
