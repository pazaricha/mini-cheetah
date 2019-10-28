# == Schema Information
#
# Table name: shopping_lists
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_shopping_lists_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class ShoppingList < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :user_id }
  belongs_to :user
end
