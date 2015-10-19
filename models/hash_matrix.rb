require File.join(File.dirname(__FILE__), 'sparse_matrix')
class HashMatrix < SparseMatrix
  def initialize
    @hash = {}
  end

  def incr(x, y)
    @hash[x] ||= {}
    @hash[x][y] ||= 0 # don't use Hash.new(0) because we still want get to return nil
    @hash[x][y] += 1
  end

  def get(x, y)
    @hash[x][y] if @hash[x]
  end

  def delete(x, y)
    if @hash[x]
      @hash[x].delete(y)
    end
  end

  def each_with_indices
    @hash.keys.sort.each do |x|
      @hash[x].keys.sort.each do |y|
        yield @hash[x][y], x, y
      end
    end
  end
end
