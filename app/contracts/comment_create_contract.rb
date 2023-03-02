class CommentCreateContract < ApplicationContract
  params do
    required(:body).filled(:string, max_size?: Comment::MAX_BODY_LENGTH)
    required(:article_id).filled(:integer)
    required(:user_id).filled(:integer)
  end
end
