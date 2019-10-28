require 'rails_helper'

RSpec.describe ShoppingListItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:shopping_list) { create(:shopping_list, user: user) }
  let(:product) { create(:product) }

  describe 'POST #create' do
    let(:base_params) do
      {
        user_id: user.id,
        shopping_list_id: shopping_list.id
      }
    end

    context 'when called with valid params' do
      let(:valid_params) do
        base_params.merge(
          product_id: product.id,
          quantity: 10
        )
      end

      it 'returns http created status' do
        post :create, params: valid_params

        expect(response).to have_http_status(:created)
      end

      it 'creates a new item' do
        expect(shopping_list.items.size).to eq(0)

        post :create, params: valid_params

        expect(shopping_list.reload.items.size).to eq(1)
      end
    end

    context 'when called with invalid params' do
      let(:invalid_params) do
        base_params.merge(
          product_id: product.id,
          quantity: -10
        )
      end

      it 'returns http created status' do
        post :create, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not creates a new item' do
        expect(shopping_list.items.size).to eq(0)

        post :create, params: invalid_params

        expect(shopping_list.reload.items.size).to eq(0)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:item) do
      create(
        :shopping_list_item,
        shopping_list: shopping_list,
        product: product
      )
    end
    let(:params) do
      {
        user_id: user.id,
        shopping_list_id: shopping_list.id,
        id: item.id
      }
    end

    it 'returns http success' do
      delete :destroy, params: params

      expect(response).to have_http_status(:success)
    end

    it 'deletes the item' do
      expect(shopping_list.items.size).to eq(1)

      delete :destroy, params: params

      expect(shopping_list.reload.items.size).to eq(0)
    end
  end

  describe 'PATCH #reposition' do
    let!(:items) do
      create_list(
        :shopping_list_item, 3,
        shopping_list: shopping_list,
        position: nil
      )

      shopping_list.items.ordered_by_position
    end
    let(:first_item) { items.first }
    let(:second_item) { items.second }
    let(:third_item) { items.third }

    context 'when called with item_id_above as nil (aka repositioned to first item)' do
      let(:params) do
        {
          user_id: user.id,
          shopping_list_id: shopping_list.id,
          id: second_item.id,
          item_id_above: nil,
          item_id_below: first_item.id
        }
      end

      it 'repositions the item to be first in the shopping_list' do
        expect(shopping_list.items.ordered_by_position.first.id).to eq(first_item.id)
        expect(shopping_list.items.ordered_by_position.second.id).to eq(second_item.id)

        patch :reposition, params: params

        expect(shopping_list.reload.items.ordered_by_position.first.id).to eq(second_item.id)
        expect(shopping_list.items.ordered_by_position.second.id).to eq(first_item.id)
      end

      it 'returns http success' do
        patch :reposition, params: params

        expect(response).to have_http_status(:success)
      end
    end

    context 'when called with item_id_below as nil (aka repositioned to last item)' do
      let(:params) do
        {
          user_id: user.id,
          shopping_list_id: shopping_list.id,
          id: second_item.id,
          item_id_above: third_item.id,
          item_id_below: nil
        }
      end

      it 'repositions the item to be first in the shopping_list' do
        expect(shopping_list.items.ordered_by_position.last.id).to eq(third_item.id)
        expect(shopping_list.items.ordered_by_position.second.id).to eq(second_item.id)

        patch :reposition, params: params

        expect(shopping_list.reload.items.ordered_by_position.last.id).to eq(second_item.id)
        expect(shopping_list.items.ordered_by_position.second.id).to eq(third_item.id)
      end

      it 'returns http success' do
        patch :reposition, params: params

        expect(response).to have_http_status(:success)
      end
    end

    context 'when called with both item_id_below and item_id_above (aka repositioned to somewhere in the middle)' do
      let(:params) do
        {
          user_id: user.id,
          shopping_list_id: shopping_list.id,
          id: first_item.id,
          item_id_above: second_item.id,
          item_id_below: third_item.id
        }
      end

      it 'repositions the item to be second in the shopping_list' do
        expect(shopping_list.items.ordered_by_position.first.id).to eq(first_item.id)
        expect(shopping_list.items.ordered_by_position.second.id).to eq(second_item.id)

        patch :reposition, params: params

        expect(shopping_list.reload.items.ordered_by_position.first.id).to eq(second_item.id)
        expect(shopping_list.items.ordered_by_position.second.id).to eq(first_item.id)
      end

      it 'returns http success' do
        patch :reposition, params: params

        expect(response).to have_http_status(:success)
      end
    end

    context 'when called with both item_id_below and item_id_above as nil' do
      let(:params) do
        {
          user_id: user.id,
          shopping_list_id: shopping_list.id,
          id: first_item.id,
          item_id_above: nil,
          item_id_below: nil
        }
      end

      it 'returns http success' do
        expect { patch :reposition, params: params }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end
