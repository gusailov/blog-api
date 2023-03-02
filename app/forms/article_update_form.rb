class ArticleUpdateForm < BaseForm
  # :title, :body, :category_id, :article_id

  def initialize(model, params)
    @model = model
    model_attributes = model.attributes.symbolize_keys.slice(:title, :body, :category_id, :article_id)

    super(model_attributes.merge(params))

    @contract = ArticleUpdateContract.new
  end

  private

  def persist!
    @model.update!(validated_params)
    @model
  end
end
