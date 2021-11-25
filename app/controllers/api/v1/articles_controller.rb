class Api::V1::ArticlesController < Api::V1::BaseController
  before_action :authenticate_user!, except: %i[index show]

  # GET /articles
  def index
    # TODO: Add a query-object that will filter Article by: date (assume the date is in ISO8601), by title (must be able to find
    articles = Article.order(created_at: :desc).page(params[:page]).per(params[:per])

    render json: articles, each_serializer: ArticlesSerializer
  end

  # GET /articles/1
  def show
    article = Article.find(params[:id])
    render json: article, serializer: ArticleSerializer
  end

  # POST /articles
  def create
    # TODO: use form object instead of model validations
    article = current_user.articles.new(article_params)
    authorize article

    if article.save
      render json: article, status: :created, serializer: ArticleSerializer
    else
      render json: { errors: article.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    article = Article.find(params[:id])
    authorize article

    if article.update(article_params)
      render json: article, serializer: ArticleSerializer
    else
      render json: { errors: article.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    article = Article.find(params[:id])
    authorize article

    article.destroy
    head :no_content
  end

  private

  # Only allow a list of trusted parameters through.
  def article_params
    # TODO: don't use require, just use permit(:...)
    params.require(:article).permit(:title, :body, :category_id)
  end
end
