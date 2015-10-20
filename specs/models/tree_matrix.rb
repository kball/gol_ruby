require File.join(File.dirname(__FILE__), '../../models/tree_matrix')

describe TreeMatrix do

  it "Should be able to set and get a value" do
    @tree_matrix = TreeMatrix.new
    @tree_matrix.incr(1, 1)
    @tree_matrix.incr(1, 1)
    @tree_matrix.incr(1, 1)
    @tree_matrix.get(1, 1).should == 3
  end
  it "Should be able to set and delete" do
    @tree_matrix = TreeMatrix.new
    @tree_matrix.incr(1, 1)
    @tree_matrix.get(1, 1).should == 1
    @tree_matrix.delete(1, 1)
    @tree_matrix.get(1, 1).should == nil
  end

  it "Should be able to set and delete with multiple in a subtree" do
    @tree_matrix = TreeMatrix.new
    @tree_matrix.incr(1, 1)
    @tree_matrix.incr(1, 2)
    @tree_matrix.incr(1, 3)
    @tree_matrix.get(1, 1).should == 1
    @tree_matrix.get(1, 2).should == 1
    @tree_matrix.get(1, 3).should == 1
    @tree_matrix.delete(1, 1)
    @tree_matrix.delete(1, 2)
    @tree_matrix.delete(1, 3)
    @tree_matrix.get(1, 1).should == nil
    @tree_matrix.get(1, 2).should == nil
    @tree_matrix.get(1, 3).should == nil
    count = 0
    @tree_matrix.each_with_indices {count += 1}
    count.should == 0
  end

  it "Should be able to set and delete with multiple nested trees" do
    @tree_matrix = TreeMatrix.new
    @tree_matrix.incr(1, 1)
    @tree_matrix.incr(1, 2)
    @tree_matrix.incr(1, 3)
    @tree_matrix.incr(2, 1)
    @tree_matrix.incr(2, 2)
    @tree_matrix.incr(2, 3)
    @tree_matrix.delete(2, 1)
    @tree_matrix.delete(2, 2)
    @tree_matrix.delete(2, 3)
    @tree_matrix.get(2, 1).should == nil
    @tree_matrix.get(2, 2).should == nil
    @tree_matrix.get(2, 3).should == nil
    count = 0
    @tree_matrix.each_with_indices {count += 1}
    count.should == 3
  end

  it "Should be able to iterate through each value once" do
    @tree_matrix = TreeMatrix.new
    values = {
      0 => {1 => 1},
      1 => {2 => 1},
      2 => {0 => 1, 1 => 1, 2 => 1},
    }

    values.each {|x, h| h.keys.each {|y| puts "incr #{x}, #{y}"; @tree_matrix.incr(x, y)}}
    @tree_matrix.each_with_indices do |i, x, y|
      puts "checking #{i}, #{x}, #{y}"
      values[x][y].should == i
    end
  end
end
