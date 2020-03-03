# frozen_string_literal: true

module Persona
  class User < ApplicationRecord
    has_and_belongs_to_many :sessions

    has_many :posts

    validates :login, uniqueness: true
  end
end
