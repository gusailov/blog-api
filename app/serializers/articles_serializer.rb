class ArticlesSerializer < ActiveModel::Serializer
  attributes :id, :title, :body_cut, :created_at

  belongs_to :category
  belongs_to :user

  def body_cut
    object.body.truncate(500)
  end
end
