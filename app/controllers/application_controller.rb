class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit

  rescue_from Pundit::NotAuthorizedError do
    head :forbidden
  end
end
