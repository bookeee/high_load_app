# frozen_string_literal: true

module Services
  module Settings
    module Cachings
      class Get
        SETTINGS_MAPPING = { top_posts_query: { caching_time: 'top_posts_caching_time',
                                                limit: 'top_posts_limit' } }.freeze

        def self.call(query, setting_name)
          settings.public_send(field(query, setting_name))
        end

        def self.settings
          @settings ||= ::Settings::Caching.first
        end

        def self.field(query, setting_name)
          SETTINGS_MAPPING[query.to_sym][setting_name.to_sym]
        end
      end
    end
  end
end
