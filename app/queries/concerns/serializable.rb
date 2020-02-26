# frozen_string_literal: true

module Serializable
  def serialize(array)
    array.to_json
  end

  def deserialize(string)
    JSON.parse(string)
  rescue StandardError
    nil
  end
end
