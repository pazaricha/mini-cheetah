class AddIndexToShoppingListItemPosition < ActiveRecord::Migration[5.2]
  def change
    add_index :shopping_list_items, :position
  end
end
