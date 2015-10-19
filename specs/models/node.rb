require File.join(File.dirname(__FILE__), '../../models/node')

describe Node do

  it "Should create a set of nested binary trees for x/y coordinates" do
    node = Node.new(1, 5)
    node.add_node(1, 4)
    node.add_node(1, 3)
    node.add_node(1, 2)
    node.add_node(2, 5)
    node.left.should == nil
    node.right.value.should == 2
    node.to_a.size.should == 2
    node.subtree.to_a.size.should == 4
    node.subtree.to_a.map(&:value).should == [2,3,4,5]
  end
end
