require File.join(File.dirname(__FILE__), 'hash_matrix')
require File.join(File.dirname(__FILE__), 'file_matrix')

require "active_support/core_ext/string" #for underscore

class Board

  attr_reader :matrices, :matrix_type
  def initialize(matrix_class = HashMatrix)
    @matrices = []
    @current_generation = 0
    @matrix_class = matrix_class
    @matrix_type = matrix_class.name.underscore.split('_').first
  end

  def new_matrix_class(generation)
    if @matrix_class == FileMatrix
      @matrix_class.new("g#{generation}")
    else
      @matrix_class.new
    end
  end

  def add_tuple(x, y, generation = nil)
    generation ||= @current_generation
    self.matrices[generation] ||= new_matrix_class(generation)
    self.matrices[generation].incr(x, y)
  end

  def prune_generation(generation)
    deletions = []
    self.matrices[generation].each_with_indices do |count, x, y|
      if count == 2
        if self.matrices[generation - 1].get(x, y)
          next
        else
          deletions.push([x, y])
        end
      elsif count == 3
        next
      else
        deletions.push([x, y])
      end
    end
    deletions.each do |pair|
      self.matrices[generation].delete(*pair)
    end
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
    self.matrices[@current_generation].each_with_indices do |count, x, y|
      self.each_neighbor(x, y) do |x2, y2|
        self.add_tuple(x2, y2, next_generation)
      end
    end
    prune_generation(next_generation)
    # Only keep one generation around at a time for space constraints
    self.matrices[@current_generation].destroy
    self.matrices[@current_generation] = nil;
    @current_generation = next_generation
  end

  def to_a(generation = nil)
    generation ||= @current_generation
    arr = []
    self.matrices[generation].each_with_indices do |count, x, y|
      arr.push({x: x, y: y})
    end
    arr
  end

  def puts_generation(generation = nil)
    self.to_a.each do |pair|
      puts "(#{pair[:x]}, #{pair[:y]})"
    end
  end

  def between(min, max)
    arr = []
    self.matrices[@current_generation].in_range(min, max, min, max) do |count, x, y|
      arr.push({x: x, y: y})
    end
    arr
  end

  def self.matrix_class_from_type(type)
    case type
    when "file"
      FileMatrix
    else
      HashMatrix
    end
  end

  def self.initialize_from_io(io, matrix_type = nil)
    board = self.new(matrix_class_from_type(matrix_type))
    io.each_line do |line|
      resp = line.match(/\(([-\d]+),\s?([-\d]+)\)/)
      if resp
        x = resp[1].to_i
        y = resp[2].to_i
        board.add_tuple(x, y)
      end
    end
    board.puts_generation
    board
  end

  def self.initialize_from_file(filename, matrix_type = nil)
    File.open(filename, 'r') do |f|
      self.initialize_from_io(f, matrix_type)
    end
  end


end
