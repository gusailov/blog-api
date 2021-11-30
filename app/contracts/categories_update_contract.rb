class CategoriesUpdateContract < ApplicationContract
  params do
    required(:name).filled(:string, max_size?: Category::MAX_NAME_LENGTH)
  end

  rule(:name) do
    key.failure(:taken) if Category.exists?(name: value)
  end
end
