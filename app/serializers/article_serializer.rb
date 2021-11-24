class ArticleSerializer < ActiveModel::Serializer
  # TODO: if you serializer a date/datetime - use iso8601 format please
  attributes :id, :title, :body, :created_at

  # TODO: always use serializers and set them explicitly
  belongs_to :category
  # TODO: always use serializers and set them explicitly
  has_many :comments
end
