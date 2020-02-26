# frozen_string_literal: true

class WrongPostsAmount < StandardError
  attr_reader :message

  def initialize(message = 'Should be not more not less then 1 and not more then 200000!')
    @message = message
  end
end
