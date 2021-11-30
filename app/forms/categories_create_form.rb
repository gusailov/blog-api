class CategoriesCreateForm < BaseForm
  def initialize(params)
    super(params)

    @contract = CategoriesCreateContract.new
  end

  private

  def persist!
    @model = Category.create!(validated_params)
  end
end
