class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { maximum: 100 }

  enum category: %i[common sport music]
  default_scope { order(created_at: :asc) }
end
