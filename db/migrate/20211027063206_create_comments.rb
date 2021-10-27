class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false, limit: 1000

      t.timestamps
    end
  end
end
