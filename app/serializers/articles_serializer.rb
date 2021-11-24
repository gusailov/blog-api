class ArticlesSerializer < ActiveModel::Serializer
  attributes :id, :title, :body_cut, :created_at

  # TODO: always use serializers and set them explicitly
  belongs_to :category
  # TODO: always use serializers and set them explicitly
  belongs_to :user

  # TODO: write specs to cover this method with tests
  def body_cut
    object.body.truncate(500)
  end
end
