class CategoriesCreateForm < BaseForm
  include ActiveModel::Model

  # attr_accessor :name

  validates :name, presence: true
  validate :name_is_unique?

  private

  def persist!
    @model = Category.create!(name: name)
  end

  def name_is_unique?
    if Category.exists?(name: name)
      errors.add(:name, I18n.t('errors.messages.taken'))
    end
  end
end
