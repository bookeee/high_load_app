# frozen_string_literal: true

module Posts
  class PostsPresenter < Presenter
    def as_json(*)
      [post]
    end

    private

    def post
      @object.map { |post| PostPresenter.new(post) }
    end
  end
end
