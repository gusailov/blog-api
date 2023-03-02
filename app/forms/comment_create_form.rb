class CommentCreateForm < BaseForm
  def initialize(params)
    super(params)

    @contract = CommentCreateContract.new
  end

  private

  def persist!
    @model = Comment.create!(validated_params)
  end
end
