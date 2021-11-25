class Api::V1::CategoriesController < Api::V1::BaseController
  before_action :authenticate_user!, except: %i[index show]

  # GET /categories
  def index
    categories = Category.all.page(params[:page]).per(params[:per])

    render json: categories, each_serializer: CategorySerializer
  end

  # GET /categories/1
  def show
    category = Category.find(params[:id])

    render json: category, serializer: CategorySerializer
  end

  # POST /categories
  def create
    category = Category.new(category_params)
    authorize category

    if category.save
      render json: category, status: :created, serializer: CategorySerializer
    else
      render json: { errors: category.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    category = Category.find(params[:id])
    authorize category

    if category.update(category_params)
      render json: category, serializer: CategorySerializer
    else
      render json: { errors: category.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    category = Category.find(params[:id])
    authorize category

    category.destroy
    head :no_content
  end

  private

  # Only allow a list of trusted parameters through.
  def category_params
    # TODO: Remove top-level require, use only .permit(:....)
    params.require(:category).permit(:name)
  end
end
