# frozen_string_literal: true

module Posts
  class PostPresenter < Presenter
    def as_json(*)
      {
        title: title,
        content: content
      }
    end

    private

    def title
      @object['title'] || @object.title
    end

    def content
      @object['content'] || @object.content
    end
  end
end
