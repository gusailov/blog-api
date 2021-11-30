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
    authorize Comment

    form = CommentCreateForm.new(create_params.merge(user_id: current_user.id).to_unsafe_hash)

    if form.save
      render json: form.model, status: :created, serializer: CommentSerializer
    else
      render json: { errors: form.errors }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    article = Article.find(params[:article_id])
    comment = article.comments.find(params[:id])
    authorize comment

    form = CommentUpdateForm.new(comment, update_params)

    if form.save
      render json: form.model, serializer: CommentSerializer
    else
      render json: { errors: form.errors }, status: :unprocessable_entity
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
  def create_params
    params.permit(:body, :article_id)
  end

  def update_params
    params.permit(:body)
  end
end
