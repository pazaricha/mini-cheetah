require 'rails_helper'

RSpec.describe ShoppingListsController, type: :controller do
  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:shopping_list) { create(:shopping_list, user: user) }

    it 'returns http success' do
      get :show, params: {
        user_id: user.id,
        id: shopping_list.id
      }

      expect(response).to have_http_status(:success)
    end

    it 'renders the request shopping_list' do
      get :show, params: {
        user_id: user.id,
        id: shopping_list.id
      }

      expect(JSON.parse(response.body)['id']).to eq(shopping_list.id)
    end
  end
end
