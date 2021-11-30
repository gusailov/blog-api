class CategoriesUpdateForm < BaseForm
  def initialize(model, params)
    @model = model
    model_attributes = model.attributes.symbolize_keys.slice(:name)

    super(model_attributes.merge(params))

    @contract = CategoriesUpdateContract.new
  end

  private

  def persist!
    @model.update!(validated_params)
    @model
  end
end
