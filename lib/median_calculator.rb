class MedianCalculatorError < StandardError; end

class MedianCalculator
  def self.median_between_to_numbers(num_x:, num_y:)
    raise MedianCalculatorError, 'num_y has to be bigger than num_x' if num_y <= num_x

    array = (num_x..num_y).to_a.sort
    len = array.length

    (array[(len - 1) / 2] + array[len / 2]) / 2
  end
end
