class ArticleUpdateForm < BaseForm
  include ActiveModel::Model

  attr_accessor :title, :body, :category_id, :article_id
  
  def initialize(model, params)
    @model = model

    super(@model.attributes.slice('title', 'body', 'category_id'))
    assign_attributes(params.except(:id))
  end

  def valid?
    contract = ArticleUpdateContract.new
    result = contract.call(title: title, category_id: category_id, body: body)

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
    @model.update!(title: title, category_id: category_id, body: body)
    @model
  end
end
