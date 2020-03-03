# frozen_string_literal: true

class Match < ApplicationRecord
  serialize :logins, Array

  validates :ip, :logins, presence: true
end
