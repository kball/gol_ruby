require File.join(File.dirname(__FILE__), '../../models/board')
require File.join(File.dirname(__FILE__), '../../models/hash_matrix')

describe Board do

  it "Should work for a glider" do
    board = Board.new(HashMatrix)
    board.add_tuple(0, 1)
    board.add_tuple(1, 2)
    board.add_tuple(2, 0)
    board.add_tuple(2, 1)
    board.add_tuple(2, 2)
    board.run_generation
    board.to_a.should == [{x: 1, y: 0}, {x: 1, y: 2}, {x: 2, y: 1}, {x: 2, y: 2}, {x:3, y:1}]
  end
end
