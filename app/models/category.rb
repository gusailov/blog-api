class Category < ApplicationRecord
  has_many :articles, dependent: :destroy

  validates :name, :body, presence: true
end
