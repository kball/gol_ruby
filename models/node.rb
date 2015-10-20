require File.join(File.dirname(__FILE__), 'tree')
class Node
  attr_accessor :left, :right, :parent, :value, :count, :subtree

  def initialize(value, subvalue = nil, parent = nil)
    self.value = value
    self.parent = parent
    self.left = nil
    self.right = nil
    self.count = 1
    if subvalue
      self.subtree = Tree.new
      self.subtree.add_node(subvalue)
    end
  end

  def add_node(value, subvalue = nil)
    if value < self.value
      self.left ? self.left.add_node(value, subvalue) :
                  self.left = Node.new(value, subvalue, self)
    elsif value > self.value
      self.right ? self.right.add_node(value, subvalue) :
                  self.right = Node.new(value, subvalue, self)
    else
      if subvalue
        self.subtree.add_node(subvalue)
        self.count += 1
      else
        self.count += 1
      end
      self
    end
  end

  def each(&block)
    self.left.each(&block) if self.left
    yield self
    self.right.each(&block) if self.right
  end

  def between(min, max, &block)
    self.left.between(min, max, &block) if min < self.value && self.left
    yield self if min < self.min && max > self.max
    self.right.between(min, max, &block) if max > self.value && self.left
  end

  def to_a
    a = []
    self.each {|x| a.push(x)}
    a
  end

  def replace_child(node, replacement)
    if self.left == node
      self.left = replacement
      replacement.parent = self if replacement
    elsif self.right == node
      self.right = replacement
      replacement.parent = self if replacement
    end
  end

  def find(value, subvalue = nil)
    if value > self.value
      self.right.find(value, subvalue) if self.right
    elsif value < self.value
      self.left.find(value, subvalue) if self.left
    else
      if subvalue
        self.subtree.find(subvalue)
      else
        self
      end
    end
  end

  def find_minimum
    self.left ? self.left.find_minimum : self
  end

  def find_maximum
    self.right ? self.right.find_maximum : self
  end

  def remove(value = nil, subvalue = nil)
    if value && value < self.value
      return self.left.remove(value, subvalue) if self.left
    elsif value && value > self.value
      return self.right.remove(value, subvalue) if self.right
    else
      if subvalue
        self.subtree.remove(subvalue)
      end
      # if we still have a subtree, don't want to actually remove this node.
      return nil unless self.subtree.nil? || self.subtree.size == 0

      if self.parent.nil? || (self.left && self.right)
        # root node with no children
        if (!self.left && !self.right)
          return self
        end
        replacement = self.right ? right.find_minimum : self.left.find_maximum
        self.value = replacement.value
        self.count = replacement.count
        self.subtree = replacement.subtree
        replacement.remove()
        self
      elsif self.parent.left == self
        self.parent.left = (self.left ? self.left : self.right)
        self.parent.left.parent = self.parent if self.parent.left
        return self
      elsif self.parent.right == self
        self.parent.right = (self.left ? self.left : self.right)
        self.parent.right.parent = self.parent if self.parent.right
        return self
      end
    end
  end
end
