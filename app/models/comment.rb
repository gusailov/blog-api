class Comment < ApplicationRecord
  MAX_BODY_LENGTH = 1000

  belongs_to :user
  belongs_to :article
end
