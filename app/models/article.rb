class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { maximum: 100 }

  scope :ordered, -> { order(created_at: :asc) }
end
