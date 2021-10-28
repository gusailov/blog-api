class Article < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { maximum: 100 }

  default_scope { order(created_at: :desc) }
end
