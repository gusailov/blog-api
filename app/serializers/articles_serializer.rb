class ArticlesSerializer < ActiveModel::Serializer
  attributes :id, :title, :body_cut, :created_at

  def body_cut
    object.body.truncate(500)
  end
end
