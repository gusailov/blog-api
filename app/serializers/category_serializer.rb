class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name

  # TODO: do not serializer huge collection without pagination, remove this please
  has_many :articles
end
