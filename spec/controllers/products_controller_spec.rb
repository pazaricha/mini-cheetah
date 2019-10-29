require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index

      expect(response).to have_http_status(:success)
    end

    context 'when called with producer_id' do
      let(:producer_a) { create(:producer) }
      let(:producer_b) { create(:producer) }
      let!(:product_producer_a) { create(:product, producer: producer_a)}
      let!(:product_producer_b) { create(:product, producer: producer_b)}

      it 'filters the returned products to only that specific producer' do
        get :index, params: {
          producer_id: producer_a.id
        }

        returned_product_ids = JSON.parse(response.body).map { |product| product['id'] }

        expect(returned_product_ids).to include(product_producer_a.id)
        expect(returned_product_ids).not_to include(product_producer_b.id)
      end
    end

    context 'restricting response attributes' do
      let!(:product) { create(:product)}

      context 'when called without attributes query string' do
        it 'returns all the attributes (without relations) in the serializer by default' do
          get :index

          rendered_product = JSON.parse(response.body).first

          expect(rendered_product.keys).to eq(
            %w(id name barcode image price sku created_at updated_at)
          )
        end
      end

      context 'when called with attributes query string' do
        let(:attributes_to_render) { %w(id name price) }

        it 'returns all the attributes (without relations) in the serializer by default' do
          get :index, params: { attributes: attributes_to_render.join(', ') }

          rendered_product = JSON.parse(response.body).first

          expect(rendered_product.keys).to eq(
            attributes_to_render
          )
        end
      end
    end

    context 'restricting response relations' do
      let!(:product) { create(:product)}

      context 'when called without relations query string' do
        it "doesn't render any relations" do
          get :index

          rendered_product = JSON.parse(response.body).first

          expect(rendered_product.keys).not_to include('producer')
        end
      end

      context 'when called with relations query string' do
        let(:relations_to_render) { 'producer' }

        it 'returns all the attributes (without relations) in the serializer by default' do
          get :index, params: { relations: relations_to_render }

          rendered_product = JSON.parse(response.body).first

          expect(rendered_product.keys).to include(relations_to_render)
        end
      end
    end
  end

  describe 'GET #show' do
    let(:product) { create(:product) }

    it 'returns http success' do
      get :show, params: { id: product.id }

      expect(response).to have_http_status(:success)
    end

    context 'restricting response attributes' do
      let!(:product) { create(:product)}

      context 'when called without attributes query string' do
        it 'returns all the attributes (without relations) in the serializer by default' do
          get :show, params: { id: product.id }

          rendered_product = JSON.parse(response.body)

          expect(rendered_product.keys).to eq(
            %w(id name barcode image price sku created_at updated_at)
          )
        end
      end

      context 'when called with attributes query string' do
        let(:attributes_to_render) { %w(id name price) }

        it 'returns all the attributes (without relations) in the serializer by default' do
          get :show, params: {
            id: product.id,
            attributes: attributes_to_render.join(', ')
          }

          rendered_product = JSON.parse(response.body)

          expect(rendered_product.keys).to eq(
            attributes_to_render
          )
        end
      end
    end

    context 'restricting response relations' do
      let!(:product) { create(:product)}

      context 'when called without relations query string' do
        it "doesn't render any relations" do
          get :show, params: {
            id: product.id,
          }

          rendered_product = JSON.parse(response.body)

          expect(rendered_product.keys).not_to include('producer')
        end
      end

      context 'when called with relations query string' do
        let(:relations_to_render) { 'producer' }

        it 'returns all the attributes (without relations) in the serializer by default' do
          get :show, params: {
            id: product.id,
            relations: relations_to_render
          }

          rendered_product = JSON.parse(response.body)

          expect(rendered_product.keys).to include(relations_to_render)
        end
      end
    end
  end
end
