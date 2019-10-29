require 'median_calculator'
require 'rails_helper'

RSpec.describe MedianCalculator do
  subject { described_class }

  describe '#median_between_to_numbers' do
    context 'when called with num_y bigger than num_x' do
      it 'raises an error' do
        expect do
          subject.median_between_to_numbers(
            num_x: 10,
            num_y: 5
          )
        end.to raise_error(MedianCalculatorError).with_message('num_y has to be bigger than num_x')
      end
    end

    context 'when called with num_x bigger than num_y' do
      it 'returns the median number between the passed 2 numbers' do
        median_number = subject.median_between_to_numbers(
          num_x: 1,
          num_y: 100
        )

        expect(median_number).to eq(50)
      end
    end

    context 'when called with num_x and num_y as the same number' do
      it 'raises an error' do
        expect do
          subject.median_between_to_numbers(
            num_x: 5,
            num_y: 5
          )
        end.to raise_error(MedianCalculatorError).with_message('num_y has to be bigger than num_x')
      end
    end
  end
end
