require 'rails_helper'

RSpec.describe ProductsController, type: :controller do

  describe 'GET #index' do
    it 'returns http success' do
      get :index

      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:product) { create(:product) }

    it 'returns http success' do
      get :show, params: { id: product.id }

      expect(response).to have_http_status(:success)
    end
  end

end
