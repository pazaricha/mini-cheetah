# == Schema Information
#
# Table name: producers
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_producers_on_name  (name) UNIQUE
#

class Producer < ApplicationRecord
  # I assumed here that there can't be multiple producers with the same name, that could be wrong though.
  validates :name, presence: true, uniqueness: true

  has_many :products
end
