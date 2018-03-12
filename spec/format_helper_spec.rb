require_relative "spec_helper"
require_relative "../helpers/format_helper"

describe FormatHelper do
  let(:h) { Object.new.extend(FormatHelper) }

  describe "#in_two" do
    describe :yielding do
      it "doesn't yield if the values are empty" do
        h.in_two([]) do
          raise "Should not yield"
        end
      end
      it "yields once for one value" do
        yield_count(["foo"]).must_equal 1
      end
      (2..10).each do |count|
        it "yields twice for #{count} values" do
          yield_count(["foo"] * count).must_equal 2
        end
      end
      def yield_count(values)
        count = 0
        h.in_two(values) { count += 1 }
        count
      end
    end

    describe :distribution_of_rows do
      it "puts half of the rows in the first column (even)" do
        col_one, col_two = columns(%w{one two three four})
        col_one.must_equal %w{one two}
        col_two.must_equal %w{three four}
      end
      it "puts half of the rows in the first column (odd)" do
        col_one, col_two = columns(%w{one two three four five})
        col_one.must_equal %w{one two three}
        col_two.must_equal %w{four five}
      end

      def columns(rows)
        columns = []
        h.in_two(rows) do |column|
          columns << column
        end
        columns
      end
    end

  end
end
