# == Schema Information
#
# Table name: shopping_list_items
#
#  id               :bigint           not null, primary key
#  position         :integer
#  quantity         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  product_id       :bigint
#  shopping_list_id :bigint
#
# Indexes
#
#  index_shopping_list_items_on_product_id        (product_id)
#  index_shopping_list_items_on_shopping_list_id  (shopping_list_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (shopping_list_id => shopping_lists.id)
#

class ShoppingListItem < ApplicationRecord
  validates :product_id, uniqueness: { scope: :shopping_list_id }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  validates :position, numericality: { greater_than_or_equal_to: 1 },
                       uniqueness: { scope: :shopping_list_id }

  belongs_to :shopping_list, dependent: :destroy
  belongs_to :product
end
