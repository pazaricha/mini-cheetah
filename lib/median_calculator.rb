class MedianCalculator
  def median_between_to_numbers(num_x, num_y)
    array = (x..y).to_a
    len = array.length
    (array[(len - 1) / 2] + array[len / 2]) / 2
  end
end
