class CommentUpdateForm < BaseForm
  include ActiveModel::Model

  attr_accessor :body
  attr_reader :model

  validates :body, presence: true, length: { maximum: Comment::MAX_BODY_LENGTH }

  def initialize(model, params)
    @model = model

    super(@model.attributes.slice('body'))
    assign_attributes(params.except(:id))
  end

  private

  def persist!
    @model.update!(body: body)
    @model
  end
end
