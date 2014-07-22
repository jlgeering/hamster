require "spec_helper"
require "hamster/tuple"
require "hamster/set"

describe Hamster::Set do
  describe "#partition" do
    [
      [[], [], []],
      [[1], [1], []],
      [[1, 2], [1], [2]],
      [[1, 2, 3], [1, 3], [2]],
      [[1, 2, 3, 4], [1, 3], [2, 4]],
      [[2, 3, 4], [3], [2, 4]],
      [[3, 4], [3], [4]],
      [[4], [], [4]],
    ].each do |values, expected_matches, expected_remainder|

      describe "on #{values.inspect}" do
        before do
          @original = Hamster.set(*values)
        end

        describe "with a block" do
          before do
            @result = @original.partition(&:odd?)
            @matches = @result.first
            @remainder = @result.last
          end

          it "preserves the original" do
            @original.should eql(Hamster.set(*values))
          end

          it "returns a tuple with two items" do
            @result.is_a?(Hamster::Tuple).should == true
            @result.size.should be(2)
          end

          it "correctly identifies the matches" do
            @matches.should eql(Hamster.set(*expected_matches))
          end

          it "correctly identifies the remainder" do
            @remainder.should eql(Hamster.set(*expected_remainder))
          end
        end

        describe "without a block" do
          before do
            @result = @original.partition
          end

          it "returns an Enumerator" do
            @result.class.should be(Enumerator)
            @result.each(&:odd?).should eql(Hamster.tuple(Hamster::Set.new(expected_matches), Hamster::Set.new(expected_remainder)))
          end
        end
      end
    end
  end
end