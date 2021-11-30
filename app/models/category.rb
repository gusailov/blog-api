class Category < ApplicationRecord
  MAX_NAME_LENGTH = 100

  has_many :articles, dependent: :destroy
end
