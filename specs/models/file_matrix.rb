require File.join(File.dirname(__FILE__), '../../models/file_matrix')

describe FileMatrix do

  it "Should be able to set and get a value" do
    @file_matrix = FileMatrix.new('test')
    @file_matrix.incr(1, 1)
    @file_matrix.incr(1, 1)
    @file_matrix.incr(1, 1)
    @file_matrix.get(1, 1).should == 3
    @file_matrix.destroy
  end

  it "Should be able to set values with different x buckets and retrieve them" do
    @file_matrix = FileMatrix.new('test')
    @file_matrix.incr(1, 1)
    @file_matrix.incr(10000, 1)
    @file_matrix.get(1, 1).should == 1
    @file_matrix.get(10000, 1).should == 1
    @file_matrix.destroy
  end

  it "Should be able to get from a range across different x buckets" do
    @file_matrix = FileMatrix.new('test')
    @file_matrix.incr(1, 1)
    @file_matrix.incr(10000, 1)
    num = 0
    @file_matrix.in_range(0, 20000, 0, 20000) do |count, x, y|
      num += 1
    end
    num.should == 2
    @file_matrix.destroy
  end
end
