# == Schema Information
#
# Table name: shopping_list_items
#
#  id               :bigint           not null, primary key
#  position         :bigint
#  quantity         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  product_id       :bigint
#  shopping_list_id :bigint
#
# Indexes
#
#  index_shopping_list_items_on_position          (position)
#  index_shopping_list_items_on_product_id        (product_id)
#  index_shopping_list_items_on_shopping_list_id  (shopping_list_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (shopping_list_id => shopping_lists.id)
#

class ShoppingListItem < ApplicationRecord
  BASE_POSITION_OFFSET_BETWEEN_ITEMS = 10_000

  validates :product_id, uniqueness: { scope: :shopping_list_id }
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  validates :position, numericality: { greater_than_or_equal_to: 1 },
                       uniqueness: { scope: :shopping_list_id }

  belongs_to :shopping_list
  belongs_to :product

  before_validation :set_default_position_if_not_provided, on: :create

  scope :ordered_by_position, -> { order(position: :asc) }

  def reposition(new_position)
    begin
      case new_position.class.to_s
      when 'Symbol'
        reposition_all_items
      when 'Fixnum', 'Bignum'
        with_lock do
          update!(position: new_position)
        end
      end
    rescue => e
      # This is where I will sent an error to an alert monitoring serivce.
      Rails.logger.error "Failed to reposition item: #{id}, to new_position: #{new_position}. Error: #{e}"

      false
    end
  end

  private

  def set_default_position_if_not_provided
    return if self.position.present?

    # I use 10,000 between each item by default so later I can do repositioning in an O(1) time complexity.
    self.position = shopping_list.items.maximum(:position).to_i + BASE_POSITION_OFFSET_BETWEEN_ITEMS
  end

  def reposition_all_items
    transaction do
      # I want my new first item to be 10_000 so I won't have to run this method again when someone moves another to be the first one.
      update!(position: BASE_POSITION_OFFSET_BETWEEN_ITEMS)

      self.shopping_list.items.ordered_by_position.find_each do |item|
        item.update!(position: item.position + (BASE_POSITION_OFFSET_BETWEEN_ITEMS) * 2)
      end
    end
  end
end
