# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  barcode     :string
#  name        :string
#  price_cents :integer          default(0)
#  sku         :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  producer_id :bigint
#
# Indexes
#
#  index_products_on_producer_id  (producer_id)
#  index_products_on_sku          (sku) UNIQUE
#

class Product < ApplicationRecord
  validates :sku, presence: true, uniqueness: true
  validates :barcode, presence: true

  belongs_to :producer, optional: true

  monetize :price_cents
end
