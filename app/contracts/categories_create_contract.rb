class CategoriesCreateContract < ApplicationContract
  params do
    required(:name).filled(:string, max_size?: Category::MAX_NAME_LENGTH)
  end

  rule(:name) do
    key.failure('has already been taken') if Category.exists?(name: value)
  end
end
