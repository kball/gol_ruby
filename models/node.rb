class Node
  attr_accessor :left, :right, :parent, :value, :count, :subtree

  def initialize(value, subvalue = nil, parent = nil)
    self.value = value
    self.parent = parent
    self.left = nil
    self.right = nil
    self.count = 1
    self.subtree = Node.new(subvalue) if subvalue
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
      else
        self.count += 1
      end
    end
  end

  def each(&block)
    self.left.each(&block) if self.left
    yield self
    self.right.each(&block) if self.right
  end

  def to_a
    a = []
    self.each {|x| a.push(x)}
    a
  end

  def prune(val_to_keep = 3)
    self.left.prune(val_to_keep) if self.left
    if self.subtree
      self.subtree.prune(val_to_keep)
    else
      self.remove unless self.value == val_to_keep
    end
    self.right.prune(val_to_keep) if self.right
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

  def find_minimum
    self.left ? self.left.find_minimum : self
  end

  def find_maximum
    self.right ? self.right.find_maximum : self
  end

  def remove
    if self.parent.nil? || (self.left && self.right)
      if self.right || self.left
        replacement = right ? right.find_minimum : left.find_maximum
        self.value = replacement.value
        self.count = replacement.count
        self.subtree = replacement.subtree
        replacement.remove
      else
        throw "Removing Root"
      end
    elsif self.left == nil && self.right == nil
      self.parent.replace_child(self, nil)
    elsif self.left == nil
      self.parent.replace_child(self, self.left)
    elsif self.right == nil
      self.parent.replace_child(self, self.right)
    end
  end
end
