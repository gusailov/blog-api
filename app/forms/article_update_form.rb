class ArticleUpdateForm < BaseForm
  include ActiveModel::Model

  attr_accessor :title, :body, :category_id, :article_id

  validates :title, presence: true, length: { maximum: Article::MAX_TITLE_LENGTH }
  validates :body, presence: true, length: { maximum: Article::MAX_BODY_LENGTH }
  validates :category_id, presence: true

  def initialize(model, params)
    @model = model

    super(@model.attributes.slice('title', 'body', 'category_id'))
    assign_attributes(params.except(:id))
  end

  private

  def persist!
    @model.update!(title: title, category_id: category_id, body: body)
    @model
  end
end
