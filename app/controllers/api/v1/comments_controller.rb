class Api::V1::CommentsController < Api::V1::BaseController
  before_action :authenticate_user!, except: :index

  # GET /comments
  def index
    article = Article.find(params[:article_id])
    comments = article.comments.order(created_at: :desc).page(params[:page]).per(params[:per])

    render json: comments, each_serializer: CommentSerializer
  end

  # POST articles/:article_id/comments
  def create
    article = Article.find(params[:article_id])
    comment = current_user.comments.new(comment_params)
    comment.article = article

    if comment.save
      render json: comment, status: :created, serializer: CommentSerializer
    else
      render json: { errors: comment.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    article = Article.find(params[:article_id])
    comment = article.comments.find(params[:id])
    authorize comment

    if comment.update(comment_params)
      render json: comment, serializer: CommentSerializer
    else
      render json: { errors: comment.errors }, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    article = Article.find(params[:article_id])
    comment = article.comments.find(params[:id])
    authorize comment

    comment.destroy
    head :no_content
  end

  private

  # Only allow a list of trusted parameters through.
  def comment_params
    # TODO: Remove top-level require, use only .permit(:....)
    params.require(:comment).permit(:body)
  end
end
