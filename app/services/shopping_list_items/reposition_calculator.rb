require 'median_calculator'

module ShoppingListItems
  class RepositionCalculator
    def initialize(item_to_reposition:, item_id_above:, item_id_below:)
      @item_to_reposition = item_to_reposition
      @item_id_above = item_id_above
      @item_id_below = item_id_below
      @shopping_list = @item_to_reposition.shopping_list
    end

    def calculate_new_position
      return position_for_first_item if @item_id_above.blank?

      return position_for_last_item if @item_id_below.blank?

      position_for_between_items
    end

    private

    def position_for_first_item
      current_first_item_position = @shopping_list.items.ordered_by_position.first.position

      if current_first_item_position > 1
        MedianCalculator.median_between_to_numbers(1, current_first_item_position)
      else
        # need to update all items by adding 10_000 to each one in one transaction
        :reposition_everything
      end
    end

    def position_for_last_item
      current_last_item_position = @shopping_list.items.ordered_by_position.last.position

      current_last_item_position + ShoppingListItem::BASE_POSITION_OFFSET_BETWEEN_ITEMS
    end

    def position_for_between_items
      above_and_below_items_positions =
      @shopping_list.items.ordered_by_position.where(
        id: [@item_id_above, @item_id_below]
      ).pluck(:position)

    MedianCalculator.median_between_to_numbers(above_and_below_items_positions.first, above_and_below_items_positions.last)
    end
  end
end