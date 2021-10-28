class AddCategoryIdToArticles < ActiveRecord::Migration[6.1]
  def change
    add_reference :articles, :category, foreign_key: true, null: false
  end
end
