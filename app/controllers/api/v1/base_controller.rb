class Api::V1::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found


  # TODO: Remove error variable, it is unused
  def record_not_found(error)
    head :not_found
  end
end
