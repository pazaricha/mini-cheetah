class ProductsController < ApplicationController
  def index
    products = Product.includes(:producer).by_producer(params[:producer_id]).page(params[:page]).all

    # render json: products.to_json(only: attributes_to_include)
    render json: products, fields: attributes_to_include, include: associations_to_include
  end

  def show
    product = Product.find(params[:id])

    # render json: product.to_json(only: attributes_to_include)
    render json: product, fields: attributes_to_include, include: associations_to_include
  end

  private

  def attributes_to_include
    if @attributes_to_include.present?
      return @attributes_to_include
    else
      attributes = params[:attributes]&.split(',')&.map(&:strip)

      initial_attributes_to_include = Product.column_names

      if attributes.blank?
        @attributes_to_include = initial_attributes_to_include
        return @attributes_to_include
      end

      @attributes_to_include = initial_attributes_to_include.reject do |column|
        attributes.exclude?(column)
      end

      @attributes_to_include
    end
  end

  def associations_to_include
    if @associations_to_include.present?
      return @associations_to_include
    else
      associations = params[:associations]&.split(',')&.map(&:strip)

      if associations.blank?
        @associations_to_include = []
        return @associations_to_include
      end

      @associations_to_include = Product.reflect_on_all_associations.map(&:name).reject do |association|
        associations.exclude?(association.to_s)
      end

      @associations_to_include
    end
  end
end
