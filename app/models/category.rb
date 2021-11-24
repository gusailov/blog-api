class Category < ApplicationRecord
  has_many :articles, dependent: :destroy

  # TODO: remove validations when you will start using FormObjects
  validates :name, presence: true, uniqueness: true
end
