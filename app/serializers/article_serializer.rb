class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at

  belongs_to :category, serializer: CategorySerializer
  belongs_to :user, serializer: UserSerializer
  has_many :comments, serializer: CommentSerializer

  def created_at
    object.created_at.iso8601
  end
end
