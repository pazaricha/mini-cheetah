class AddIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :products, :sku, unique: true
    add_index :producers, :name, unique: true
  end
end
