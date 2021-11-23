class Api::V1::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found(error)
    head :not_found
  end
end
