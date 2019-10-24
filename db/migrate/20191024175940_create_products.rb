class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :barcode
      t.integer :price_cents, default: 0
      t.uuid :sku

      t.timestamps
    end
  end
end
