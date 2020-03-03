# frozen_string_literal: true

class RequestTimer
  def initialize(app)
    @app = app
  end

  def call(env)
    env[:timestamp] = Time.zone.now
    @app.call(env)
  end
end
