# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError, with: :unexpected_error

  def unexpected_error(e)
    Rails.logger.error(e.message)
    render_error_response(e.message, 500)
  end

  def render_error_response(object, status)
    render json: { code: 422, errors: message(object) }, status: status
  end

  private

  def message(object)
    if object.is_a?(Exception)
      object.message
    else
      object.try(:errors).try(:messages)
    end
  end
end
