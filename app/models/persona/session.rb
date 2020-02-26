# frozen_string_literal: true

module Persona
  class Session < ApplicationRecord
    has_and_belongs_to_many :users

    def self.used_by_another_user?(ip, user_id)
      Queries::Sessions::UsedByOtherUsersQuery.new(ip, user_id).call.any?
    end
  end
end
