require File.join(File.dirname(__FILE__), '../../models/tree')

describe Tree do

  it "should be able to create a bidirectional array" do
    tree = Tree.new
    tree.add_node(1, 5)
    tree.add_node(1, 4)
    tree.add_node(1, 3)
    tree.add_node(1, 2)
    tree.add_node(2, 5)

    tree.size.should == 2
    tree.to_a.map(&:value).should == [1, 2]
    tree.to_a.first.subtree.to_a.map(&:value).should == [2, 3, 4, 5]
    tree.to_a.last.subtree.to_a.map(&:value).should == [5]
  end

  it "should be able to delete nodes in reverse" do
    tree = Tree.new
    tree.add_node(1, 5)
    tree.add_node(2, 6)
    tree.remove(2, 6)
    tree.remove(1, 5)
    tree.size.should == 0
    tree.to_a.should == []
  end

  it "should be able to delete nodes in order" do
    tree = Tree.new
    tree.add_node(1, 5)
    tree.add_node(2, 6)
    tree.remove(1, 5)
    tree.remove(2, 6)
    tree.size.should == 0
    tree.to_a.should == []
  end
  it "should be able to delete nodes in order within a subtree" do
    tree = Tree.new
    tree.add_node(1)
    tree.add_node(2)
    tree.add_node(3)
    tree.remove(1)
    tree.remove(2)
    tree.remove(3)
    tree.to_a.should == []
    tree.size.should == 0
  end

  it "should be able to delete nodes skipping some" do
    tree = Tree.new
    tree.add_node(-1)
    tree.add_node(0)
    tree.add_node(1)
    tree.add_node(2)
    tree.add_node(3)
    tree.remove(-1)
    tree.remove(0)
    tree.remove(3)
    tree.to_a.map(&:value).should == [1, 2]
    tree.size.should == 2
  end
end
