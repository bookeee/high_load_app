# frozen_string_literal: true

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
