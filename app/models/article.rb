class Article < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy

  # TODO: remove validations when you will start using FormObjects
  validates :title, :body, presence: true
  validates :title, length: { maximum: 100 }
end
