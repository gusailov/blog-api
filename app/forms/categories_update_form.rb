class CategoriesUpdateForm < BaseForm
  include ActiveModel::Model

  attr_accessor :name
  attr_reader :model

  validates :name, presence: true
  validate :name_is_unique?

  def initialize(model, params)
    @model = model

    super(@model.attributes.slice('name'))
    assign_attributes(params.except(:id))
  end

  private

  def persist!
    @model.update!(name: name)
    @model
  end

  def name_is_unique?
    if Category.exists?(name: name)
      errors.add(:name, I18n.t('errors.messages.taken'))
    end
  end
end
