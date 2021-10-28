class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at

  belongs_to :category
  has_many :comments
end
