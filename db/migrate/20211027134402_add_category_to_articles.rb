class AddCategoryToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :category, :integer
  end
end
