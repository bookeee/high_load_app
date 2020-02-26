# frozen_string_literal: true

class PostWithGivenIdDoesntExist < StandardError
  attr_reader :message

  def initialize(message = 'Post with given id doesnt exist')
    @message = message
  end
end
