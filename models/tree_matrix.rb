require File.join(File.dirname(__FILE__), 'sparse_matrix')
require File.join(File.dirname(__FILE__), 'tree')
class TreeMatrix < SparseMatrix
  def initialize
    @tree = Tree.new
  end

  def incr(x, y)
    @tree.add_node(x, y)
  end
  
  def get(x, y)
    node = @tree.find(x, y)
    node.count if node
  end

  def delete(x, y)
    @tree.remove(x, y)
  end

  def each_with_indices
    @tree.each do |x_node|
      x_node.each do |y_node|
        yield y_node.count, x_node.value, y_node.value
      end
    end
  end

  def in_range(xmin, xmax, ymin, ymax)
    @tree.between(xmin, xmax).each do |x_node|
      x_node.between(ymin, ymax).each do |y_node|
        yield y_node.count, x_node.value, y_node.value
      end
    end
  end
end
