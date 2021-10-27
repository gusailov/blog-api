class ArticlesSerializer < ActiveModel::Serializer
  attributes :id, :title, :category, :body_cut, :created_at

  def body_cut
    object.body.truncate(500)
  end
end
