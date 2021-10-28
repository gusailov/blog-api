class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authenticate_user!, except: :index
  before_action :set_article, only: %i[index create]
  load_and_authorize_resource class: "Comment"

  # GET /comments
  def index
    @comments = @article.comments

    render json: @comments
  end

  # GET /comments/1
  def show
    render json: @comment
  end

  # POST articles/:article_id/comments
  def create
    @comment = current_user.comments.new(comment_params)
    @comment.article = @article

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body)
  end
end
