class SparseMatrix
  # Interface class for defining how we want to interact with our sparse matrices.
  # Implementations will be HashMatrix and TreeMatrix

  def get(x, y)
    raise "Implement in subclass"
  end

  def incr(x, y)
    raise "Implement in subclass"
  end

  def delete(x, y)
    raise "Implement in subclass"
  end

  # yields value, x, y
  def each_with_indices
    raise "Implement in subclass"
  end
end
