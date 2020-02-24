# frozen_string_literal: true

module Persona
  class Session < ApplicationRecord
    has_and_belongs_to_many :users
  end
end
