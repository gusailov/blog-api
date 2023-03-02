class CommentUpdateContract < ApplicationContract
  params do
    required(:body).filled(:string, max_size?: Comment::MAX_BODY_LENGTH)
  end
end
