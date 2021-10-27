class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :category, :created_at
end
