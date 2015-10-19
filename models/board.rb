require File.join(File.dirname(__FILE__), 'node')
class Board

  attr_reader :trees
  def initialize
    @trees = []
    @current_generation = 0
  end

  def add_tuple(x, y, generation = nil)
    generation ||= @current_generation
    tree = self.trees[generation]
    if tree
      tree.add_node(x, y)
    else
      self.trees[generation] = Node.new(x, y)
    end
  end

  def prune_generation(generation)
    self.trees[generation].prune(3)
  end

  def each_neighbor(x, y)
    [[x - 1, y - 1], [x - 1, y], [x - 1, y + 1],
     [x + 1, y - 1], [x + 1, y], [x + 1, y + 1],
     [x, y - 1], [x, y + 1]].each do |pair|
      yield pair[0], pair[1]
    end
  end
  def run_generation
    next_generation = @current_generation + 1
    self.trees[@current_generation].each do |x_node|
      x_node.subtree.each do |y_node|
        x = x_node.value
        y = y_node.value
        self.each_neighbor(x, y) do |x2, y2|
          self.add_tuple(x2, y2, next_generation)
        end
      end
    end
    prune_generation(next_generation)
    @current_generation = next_generation
  end

  def to_a(generation = nil)
    generation ||= @current_generation
    arr = []
    self.trees[generation].each do |x_node|
      x_node.subtree.each do |y_node|
        arr.push({x: x_node.value, y: y_node.value})
      end
    end
    arr
  end

  def puts_generation(generation = nil)
    self.to_a.each do |pair|
      puts "(#{pair[:x]}, #{pair[:y]})"
    end
  end

  def self.initialize_from_io(io)
    board = self.new
    io.each_line do |line|
      resp = line.match(/\(([-\d]+),\s?([-\d]+)\)/)
      puts resp.inspect
      if resp
        x = resp[1].to_i
        y = resp[2].to_i
        board.add_tuple(x, y)
      end
    end
    board.puts_generation
    board
  end

  def self.initialize_from_file(filename)
    File.open(filename, 'r') do |f|
      self.initialize_from_io(f)
    end
  end


end
