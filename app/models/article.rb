class Article < ApplicationRecord
  MAX_TITLE_LENGTH = 100
  MAX_BODY_LENGTH = 50000

  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
end
