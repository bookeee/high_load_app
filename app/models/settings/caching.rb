# frozen_string_literal: true

module Settings
  class Caching < ApplicationRecord
    validate :only_one_record

    def only_one_record
      if Settings::Caching.count > 1
        errors[:base] << 'You can have only 1 instance of this model'
      end
    end
  end
end
