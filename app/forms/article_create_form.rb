class ArticleCreateForm < BaseForm
  def initialize(params)
    super(params)

    @contract = ArticleCreateContract.new
  end

  private

  def persist!
    @model = Article.create!(validated_params)
  end
end
