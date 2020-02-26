# frozen_string_literal: true

module Cacheable
  def amount_can_be_cached?(query_name)
    amount <= Services::Settings::Cachings::Get.call(query_name, 'limit')
  end

  def delete_(key)
    $redis.del(key)
  end

  def create_list(key, array)
    $redis.lpush(key, array)
  end

  def set_expiration_time(key)
    $redis.expire(key, Services::Settings::Cachings::Get.call(key, 'caching_time'))
  end

  def get_list(key, start_at, ends_at)
    $redis.lrange(key, start_at, ends_at).first
  end

  def list_count(key)
    JSON.parse($redis.lrange(key, 0, 0).first).count
  end
end
