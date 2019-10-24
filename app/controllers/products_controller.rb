class ProductsController < ApplicationController
  def index
    products = Product.select(attributes_to_include).by_producer(params[:producer_id]).page(params[:page]).all

    render json: products.to_json(only: attributes_to_include)
  end

  def show
    products = Product.select(attributes_to_include).find(params[:id])

    render json: products.to_json(only: attributes_to_include)
  end

  private

  def attributes_to_include
    if @attributes_to_include.present?
      return @attributes_to_include
    else
      attributes = params[:attributes]&.split(',')&.map(&:strip)

      if attributes.blank?
        @attributes_to_include = Product.column_names
        return @attributes_to_include
      end

      @attributes_to_include = Product.column_names.reject do |column|
        attributes.exclude?(column)
      end

      @attributes_to_include
    end
  end
end
