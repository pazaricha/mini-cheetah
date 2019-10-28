require 'median_calculator'

class ShoppingListItemsController < ApplicationController
  before_action :validate_current_user
  before_action :set_shopping_list
  before_action :set_item, only: [:destroy, :reposition]

  def create
    item = @shopping_list.items.new(create_params)

    if item.save
      render json: item, status: :created
    else
      render json: item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy!

    render json: { message: 'Item deleted successfully' }, status: :ok
  end

  def reposition
    above_and_below_items_positions =
      @shopping_list.item.ordered_by_position.where(
        id: [reposition_params[:item_id_above], reposition_params[:item_id_below]]
      ).pluck(:position)

    new_position = MedianCalculator.median_between_to_numbers(above_and_below_items_positions.first, above_and_below_items_positions.last)

    if @item.update(position: new_position)
      render json: @item, status: :ok
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  private

  def set_shopping_list
    @shopping_list = current_user.shopping_lists.find(params[:shopping_list_id])
  end

  def set_item
    @item = @shopping_list.items.find(params[:id])
  end

  def create_params
    params.require(:shopping_list_id)
    params.permit(:product_id, :quantity)
  end

  def reposition_params
    params.require(:shopping_list_id)
    params.permit(:item_id_above, :item_id_below)
  end
end
