class CommentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :article_id, :body, :created_at

  def created_at
    object.created_at.iso8601
  end
end
