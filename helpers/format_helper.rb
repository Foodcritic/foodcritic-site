module FormatHelper

  def in_two(rows)
    mid_way = (rows.count.to_f / 2).round
    rows.each_slice(mid_way) do |slice|
      yield slice
    end
  end

end
