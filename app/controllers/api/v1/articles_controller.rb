class Api::V1::ArticlesController < Api::V1::BaseController
  before_action :authenticate_user!, except: %i[index show]

  # GET /articles
  def index
    filtered_articles = ArticleFilter.new(Article.all).call(filter_params)
    articles = filtered_articles.order(created_at: :desc).page(params[:page]).per(params[:per])

    render json: articles, each_serializer: ArticlesSerializer
  end

  # GET /articles/1
  def show
    article = Article.find(params[:id])
    render json: article, serializer: ArticleSerializer
  end

  # POST /articles
  def create
    authorize Article

    form = ArticleCreateForm.new(article_params.merge({ user_id: current_user.id }).to_unsafe_hash)

    if form.save
      render json: form.model, status: :created, serializer: ArticleSerializer
    else
      render json: { errors: form.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    article = Article.find(params[:id])
    authorize article

    form = ArticleUpdateForm.new(article, article_params)

    if form.save
      render json: form.model, serializer: ArticleSerializer
    else
      render json: { errors: form.errors }, status: :unprocessable_entity
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
    params.permit(:title, :body, :category_id)
  end

  def filter_params
    params.permit(:search, :date)
  end
end
