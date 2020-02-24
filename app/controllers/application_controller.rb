# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError, with: :unexpected_error

  def unexpected_error(e)
    Rails.logger.error(e.message)
    render_error_response(e.message, 500)
  end

  def render_error_response(message, status)
    render json: { error: message }, status: status
  end
end
