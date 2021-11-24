class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  # TODO: remove validations when you will start using FormObjects
  validates :body, presence: true
  validates :body, length: { maximum: 1000 }
end
