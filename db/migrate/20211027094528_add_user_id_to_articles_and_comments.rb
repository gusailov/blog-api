class AddUserIdToArticlesAndComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :articles, :user, foreign_key: true, null: false
    add_reference :comments, :user, foreign_key: true, null: false
  end
end
