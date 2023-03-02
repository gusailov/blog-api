class ArticleCreateContract < ApplicationContract
  params do
    required(:title).filled(:string, max_size?: Article::MAX_TITLE_LENGTH)
    required(:body).filled(:string, max_size?: Article::MAX_BODY_LENGTH)
    required(:category_id).filled(:integer)
    required(:user_id).filled(:integer)
  end
end
