unless Rails.env.test?
  $redis = Redis::Namespace.new("high_load_app", redis: Redis.new )
else
  $redis = Redis::Namespace.new("high_load_app", redis: MockRedis.new )
end