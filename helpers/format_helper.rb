module FormatHelper

  def in_two(values)
    return if values.empty?
    mid_way = (values.count.to_f / 2).round
    values.each_slice(mid_way) do |column|
      yield column
    end
  end

end
