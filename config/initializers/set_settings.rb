Settings::Caching.delete_all
Settings::Caching.create!(top_posts_caching_time: ENV["TOP_POSTS_CACHING_TIME"], top_posts_limit: ENV["TOP_POSTS_LIMIT"])


