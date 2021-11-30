class ArticleCreateForm < BaseForm
  include ActiveModel::Model

  attr_accessor :title, :body, :category_id, :user_id
  attr_reader :model

  validates :title, presence: true, length: { maximum: Article::MAX_TITLE_LENGTH }
  validates :body, presence: true, length: { maximum: Article::MAX_BODY_LENGTH }
  validates :category_id, presence: true
  validates :user_id, presence: true

  private

  def persist!
    @model = Article.create!(title: title, category_id: category_id, body: body, user_id: user_id)
  end
end
