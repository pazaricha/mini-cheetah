class ChangeShoppingListItemPositionFromIntegerToBigint < ActiveRecord::Migration[5.2]
  def change
    change_column :shopping_list_items, :position, :bigint
  end
end
