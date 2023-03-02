class CategoriesUpdateContract < ApplicationContract
  params do
    required(:name).filled(:string, max_size?: Category::MAX_NAME_LENGTH)
  end

  rule(:name) do
    key.failure(I18n.t('dry_validation.errors.taken')) if Category.exists?(name: value)
  end
end
