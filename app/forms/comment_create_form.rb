class CommentCreateForm < BaseForm
  include ActiveModel::Model

  attr_accessor :body, :article_id, :user_id

  validates :body, presence: true, length: { maximum: Comment::MAX_BODY_LENGTH }
  validates :article_id, presence: true
  validates :user_id, presence: true

  private

  def persist!
    @model = Comment.create!(article_id: article_id, body: body, user_id: user_id)
  end
end
