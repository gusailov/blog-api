class Api::V1::CategoriesController < Api::V1::BaseController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_category, only: [:show, :update, :destroy]
  load_and_authorize_resource class: "Category"

  # GET /categories
  def index
    # TODO: don't use instance variables if you don't need them
    @categories = Category.all

    render json: @categories
  end

  # GET /categories/1
  def show
    # TODO: user Category.find(params[:id]) instead of auto-finders from cancancan or before_actions

    render json: @category
  end

  # POST /categories
  def create
    # TODO: don't use instance variables if you don't need them
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    # TODO: user Category.find(params[:id]) instead of auto-finders from cancancan or before_actions
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    # TODO: user Category.find(params[:id]) instead of auto-finders from cancancan or before_actions
    @category.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  # TODO: user Category.find(params[:id]) instead of auto-finders from cancancan or before_actions
  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def category_params
    # TODO: Remove top-level require, use only .permit(:....)
    params.require(:category).permit(:name)
  end
end
