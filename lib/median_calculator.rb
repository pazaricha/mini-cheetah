class MedianCalculator
  def self.median_between_to_numbers(num_x, num_y)
    array = (num_x..num_y).to_a
    len = array.length
    (array[(len - 1) / 2] + array[len / 2]) / 2
  end
end
