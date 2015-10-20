require File.join(File.dirname(__FILE__), '../../models/file_matrix')

describe FileMatrix do

  it "Should be able to set and get a value" do
    @file_matrix = FileMatrix.new('test')
    @file_matrix.incr(1, 1)
    @file_matrix.incr(1, 1)
    @file_matrix.incr(1, 1)
    @file_matrix.get(1, 1).should == 3
  end

  it "Should be able to set values with different x buckets and retrieve them" do
    @file_matrix = FileMatrix.new('test')
    @file_matrix.incr(1, 1)
    @file_matrix.incr(10000, 1)
    @file_matrix.get(1, 1).should == 1
    @file_matrix.get(10000, 1).should == 1
  end
end
