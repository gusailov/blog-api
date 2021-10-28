class Api::V1::ArticlesController < Api::V1::BaseController
  before_action :authenticate_user!, except: %i[index show]
  load_and_authorize_resource class: "Article"

  # GET /articles
  def index
    @articles = Article.all

    render json: @articles, each_serializer: ArticlesSerializer
  end

  # GET /articles/1
  def show
    render json: @article
  end

  # POST /articles
  def create
    @article = current_user.articles.new(article_params)

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
  end

  private

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :body, :category_id)
  end
end
