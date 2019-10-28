class ShoppingListsController < ApplicationController
  before_action :validate_current_user

  def show
    shopping_list = current_user.shopping_lists.find(params[:id])

    render json: shopping_list, page: params[:page]
  end
end
