require 'rails_helper'

RSpec.describe ShoppingListItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:shopping_list) { create(:shopping_list, user: user) }

  describe "POST #create" do
    let(:base_params) do
      {
        user_id: user.id,
        shopping_list_id: shopping_list.id
      }
    end

    context 'when passed with valid params' do
      let(:product) { create(:product) }
      let(:valid_params) do
        base_params.merge(
          product_id: product.id,
          quantity: 10
        )
      end

      it "returns http created status" do
        post :create, params: valid_params

        expect(response).to have_http_status(:created)
      end

      it "creates a new item" do
        expect(shopping_list.items.size).to eq(0)

        post :create, params: valid_params

        expect(shopping_list.reload.items.size).to eq(1)
      end
    end
  end

  describe "DELETE #destroy" do
    it "returns http success" do
      delete :destroy, params: {
        shopping_list_id: shopping_list.id,
        id: item.id
      }

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #reposition" do
    it "returns http success" do
      patch :reposition
      expect(response).to have_http_status(:success)
    end
  end

end
