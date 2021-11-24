class Api::V1::ArticlesController < Api::V1::BaseController
  before_action :authenticate_user!, except: %i[index show]
  # TODO: Use pundit instead of cancancan
  load_and_authorize_resource class: "Article"

  # GET /articles
  def index
    # TODO: Add pagination (with default values - page 1, per 20) and ordering (by date)
    # TODO: Add a query-object that will filter Article by: date (assume the date is in ISO8601), by title (must be able to find
    # article even by a part of it's title)
    articles = Article.all

    render json: articles, each_serializer: ArticlesSerializer
  end

  # GET /articles/1
  def show
    # TODO: user Article.find(params[:id]) instead of auto-finders from cancancan or before_actions
    # TODO: always use serializers and set them explicitly
    render json: @article
  end

  # POST /articles
  def create
    # TODO: use form object instead of model validations
    article = current_user.articles.new(article_params)

    if article.save
      # TODO: always use serializers and set them explicitly
      render json: article, status: :created
    else
      render json: {errors: article.errors}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    # TODO: user Article.find(params[:id]) instead of auto-finders from cancancan or before_actions
    if @article.update(article_params)
      # TODO: always use serializers and set them explicitly
      render json: @article
    else
      render json: {errors: @article.errors}, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    # TODO: user Article.find(params[:id]) instead of auto-finders from cancancan or before_actions
    @article.destroy

    head :no_content
  end

  private

  # Only allow a list of trusted parameters through.
  def article_params
    # TODO: don't use require, just use permit(:...)
    params.require(:article).permit(:title, :body, :category_id)
  end
end
