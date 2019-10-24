class AddProducerIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :producer
  end
end
