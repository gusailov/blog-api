class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article

  validates :body, presence: true
  validates :body, length: { maximum: 1000 }
end
