class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at

  belongs_to :category
end
