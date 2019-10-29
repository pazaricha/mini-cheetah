class ProductsController < ApplicationController
  def index
    products = Product.includes(:producer).by_producer(params[:producer_id]).page(params[:page]).all

    render json: products, fields: attributes_to_include, include: relations_to_include
  end

  def show
    product = Product.find(params[:id])

    render json: product, fields: attributes_to_include, include: relations_to_include
  end

  private

  def attributes_to_include
    if @attributes_to_include.present?
      return @attributes_to_include
    else
      attributes = params[:attributes]&.split(',')&.map(&:strip)

      initial_attributes_to_include = Product.column_names + ['price']

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

  def relations_to_include
    if @relations_to_include.present?
      return @relations_to_include
    else
      relations = params[:relations]&.split(',')&.map(&:strip)

      if relations.blank?
        @relations_to_include = []
        return @relations_to_include
      end

      @relations_to_include = Product.reflect_on_all_associations.map(&:name).reject do |association|
        relations.exclude?(association.to_s)
      end

      @relations_to_include
    end
  end
end
