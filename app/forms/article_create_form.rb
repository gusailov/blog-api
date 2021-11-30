class ArticleCreateForm < BaseForm
  include ActiveModel::Model

  attr_accessor :title, :body, :category_id, :user_id, :errors, :validated_params

  def valid?
    contract = ArticleCreateContract.new
    result = contract.call(title: title, category_id: category_id, body: body, user_id: user_id)

    if result.success?
      @validated_params = result.values.data
      true
    else
      @errors = result.errors.to_h
      false
    end
  end

  private

  def persist!
    @model = Article.create!(validated_params)
  end
end
