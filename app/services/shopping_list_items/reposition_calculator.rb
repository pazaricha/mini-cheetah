require 'median_calculator'

module ShoppingListItems
  class RepositionCalculator
    # item_to_reposition: the item we are trying to reposition
    # item_id_above: the id of the item that is going to be above our item_to_reposition after he will be moved to his new position.
    # item_id_below: the id of the item that is going to be below our item_to_reposition after he will be moved to his new position.
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
      current_smallest_position = @shopping_list.items.minimum(:position).to_i

      if current_smallest_position > 1
        MedianCalculator.median_between_to_numbers(num_x: 1, num_y: current_smallest_position)
      else
        # need to update all items
        :reposition_everything
      end
    end

    def position_for_last_item
      current_biggest_position = @shopping_list.items.maximum(:position).to_i

      current_biggest_position + ShoppingListItem::BASE_POSITION_OFFSET_BETWEEN_ITEMS
    end

    def position_for_between_items
      above_and_below_items_positions =
      @shopping_list.items.ordered_by_position.where(
        id: [@item_id_above, @item_id_below]
      ).pluck(:position)

    MedianCalculator.median_between_to_numbers(num_x: above_and_below_items_positions.first, num_y: above_and_below_items_positions.last)
    end
  end
end
