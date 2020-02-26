# frozen_string_literal: true

class Match < ApplicationRecord
  serialize :logins, Array

  validates_presence_of :ip, :logins
end
