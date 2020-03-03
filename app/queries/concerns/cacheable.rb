# frozen_string_literal: true

module Cacheable
  def amount_can_be_cached?(query)
    amount <= limit(query)
  end

  def limit(query)
    Services::Settings::Cachings::Get.call(query, 'limit')
  end

  def delete_(key)
    $redis.del(key)
  end

  def create_list(key, array)
    $redis.lpush(key, array)
  end

  def set_expiration_time(key)
    $redis.expire(key, caching_time(key))
  end

  def caching_time(query)
    Services::Settings::Cachings::Get.call(query, 'caching_time')
  end

  def get_list(key, starts_at, ends_at)
    $redis.lrange(key, starts_at, ends_at).first
  end

  def key_exists?(key)
    $redis.keys(key.to_s).any?
  end
end
