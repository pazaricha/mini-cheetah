class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :barcode, :image, :price, :sku,
    :created_at, :updated_at, :producer

  belongs_to :producer
end
