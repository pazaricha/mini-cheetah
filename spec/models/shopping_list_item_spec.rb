require 'rails_helper'

RSpec.describe ShoppingListItem, type: :model do
  describe '#reposition' do
    let(:shopping_list) { create(:shopping_list) }
    let(:first_item_original_position) { 1000 }
    let(:second_item_original_position) { 2000 }
    let(:third_item_original_position) { 3000 }
    let!(:first_item) do
      create(
        :shopping_list_item,
        shopping_list: shopping_list,
        position: first_item_original_position
      )
    end
    let!(:second_item) do
      create(
        :shopping_list_item,
        shopping_list: shopping_list,
        position: second_item_original_position
      )
    end
    let!(:third_item) do
      create(
        :shopping_list_item,
        shopping_list: shopping_list,
        position: third_item_original_position
      )
    end

    context 'when called with a number bigger than 0' do
      let(:new_position) { 4000 }

      it "updates the current item's position to the passed number" do
        second_item.reposition(new_position)

        expect(second_item.reload.position).to eq(new_position)
      end
    end

    context 'when called with a number smaller or equal to 0' do
      let(:new_position) { 0 }

      it "updates all the shopping_list's items positions" do
        second_item.reposition(new_position)

        expect(second_item.reload.position).to eq(ShoppingListItem::BASE_POSITION_OFFSET_BETWEEN_ITEMS)

        expect(first_item.reload.position).to eq(first_item_original_position + (ShoppingListItem::BASE_POSITION_OFFSET_BETWEEN_ITEMS * 2))

        expect(third_item.reload.position).to eq(third_item_original_position + (ShoppingListItem::BASE_POSITION_OFFSET_BETWEEN_ITEMS * 2))
      end
    end

    context 'when an error is raised during the reposition' do
      let(:new_position) { 0 }

      it 'returns false' do
        allow(second_item).to receive(:reposition_all_items).and_raise('random error')

        expect(second_item.reposition(new_position)).to eq(false)
      end
    end
  end
end
