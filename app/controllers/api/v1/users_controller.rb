class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: %i[show]

  # GET /users/1
  def show
    render json: @user.articles
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # TODO: don't use finders, find model explicitly
  def set_user
    @user = User.find(params[:id])
  end
end
