class CreateShoppingListItems < ActiveRecord::Migration[5.2]
  def change
    create_table :shopping_list_items do |t|
      t.references :shopping_list, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :quantity
      t.integer :position

      t.timestamps
    end
  end
end
