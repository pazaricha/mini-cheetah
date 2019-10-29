require 'rails_helper'

RSpec.describe ShoppingListItems::RepositionCalculator do
  let(:shopping_list) { create(:shopping_list) }
  let(:first_item_position) { 1000 }
  let(:second_item_position) { 2000 }
  let(:third_item_position) { 3000 }
  let(:first_item) do
    create(
      :shopping_list_item,
      shopping_list: shopping_list,
      position: first_item_position
    )
  end
  let(:second_item) do
    create(
      :shopping_list_item,
      shopping_list: shopping_list,
      position: second_item_position
    )
  end
  let(:third_item) do
    create(
      :shopping_list_item,
      shopping_list: shopping_list,
      position: third_item_position
    )
  end

  describe '#calculate_new_position' do
    context 'when item_id_above is blank' do
      context "and when the current first item's position in the shopping_list is 1" do
        let(:first_item_position) { 1 }
        let(:second_item_position) { 50 }
        let(:third_item_position) { 100 }

        subject do
          described_class.new(
            item_to_reposition: second_item,
            item_id_above: nil,
            item_id_below: first_item
          )
        end

        it 'returns 0 which will indicate all items need to be repositioned' do
          expect(subject.calculate_new_position).to eq(0)
        end
      end

      context "and when the current first item's position in the shopping_list is bigger than 1" do
        subject do
          described_class.new(
            item_to_reposition: second_item,
            item_id_above: nil,
            item_id_below: first_item
          )
        end

        it "returns the median number between 1 and the current first item's position" do
          expect(subject.calculate_new_position).to eq(500)
        end
      end
    end

    context 'when item_id_below is blank' do
      subject do
        described_class.new(
          item_to_reposition: second_item,
          item_id_above: third_item,
          item_id_below: nil
        )
      end

      it "returns the current biggest position in the shopping_list's items + ShoppingListItem::BASE_POSITION_OFFSET_BETWEEN_ITEMS" do
        expect(subject.calculate_new_position).to eq(third_item_position + ShoppingListItem::BASE_POSITION_OFFSET_BETWEEN_ITEMS)
      end
    end

    context 'when both item_id_above and item_id_below are provided' do
      subject do
        described_class.new(
          item_to_reposition: first_item,
          item_id_above: second_item,
          item_id_below: third_item
        )
      end

      it "returns the median number between the item_above's and item_below's positions" do
        expect(subject.calculate_new_position).to eq(2500)
      end
    end
  end
end
