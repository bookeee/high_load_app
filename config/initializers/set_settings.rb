def setup
  Settings::Caching.delete_all
  Settings::Caching.create!(top_posts_caching_time: ENV["TOP_POSTS_CACHING_TIME"], top_posts_limit: ENV["TOP_POSTS_LIMIT"])
rescue ActiveRecord::StatementInvalid => e
  if e.cause.is_a?(PG::UndefinedTable)
    puts "You should define tables (rake db:migrate) first."
  end
end


if Rails.env.development?
  setup
end
