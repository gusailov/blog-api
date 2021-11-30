class CommentUpdateForm < BaseForm
  def initialize(model, params)
    @model = model
    model_attributes = model.attributes.symbolize_keys.slice(:body)

    super(model_attributes.merge(params))

    @contract = CommentUpdateContract.new
  end

  private

  def persist!
    @model.update!(validated_params)
    @model
  end
end
