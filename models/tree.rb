require File.join(File.dirname(__FILE__), 'node')
class Tree
  attr_reader :size
  def initialize
    @root = nil
    @size = 0
  end

  def add_node(value, subvalue = nil)
    if @root
      node = @root.add_node(value, subvalue)
      @size += 1 if node.count == 1
    else
      @root = Node.new(value, subvalue)
      @size = 1
    end
  end

  def find(value, subvalue = nil)
    if @root
      @root.find(value, subvalue)
    else
      nil
    end
  end

  def each(&block)
    if @root
      @root.each(&block)
    end
  end

  def between(min, max, &block)
    if @root
      @root.between(min, max, &block)
    end
  end

  def remove(value, subvalue = nil)
    if @root
      node = @root.remove(value, subvalue)
      @size -= 1 if node
      @root = nil if @size == 0
    end
  end

  def to_a
    @root ? @root.to_a : []
  end
end
