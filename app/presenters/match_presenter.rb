# frozen_string_literal: true

class MatchPresenter < Presenter
  def as_json(*)
    {
      ip: ip,
      logins: logins
    }
  end

  private

  def ip
    @object.ip
  end

  def logins
    @object.logins
  end
end
