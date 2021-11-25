class ArticlesSerializer < ActiveModel::Serializer
  attributes :id, :title, :body_cut, :created_at

  belongs_to :category, serializer: CategorySerializer
  belongs_to :user, serializer: UserSerializer

  def body_cut
    object.body.truncate(500)
  end

  def created_at
    object.created_at.iso8601
  end
end
