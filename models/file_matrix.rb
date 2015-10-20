require File.join(File.dirname(__FILE__), 'sparse_matrix')
require 'fileutils'

class FileMatrix < SparseMatrix
  def initialize(path)
    @path = File.join(File.join(File.dirname(__FILE__), '../data/'), path)
    unless File.directory?(@path)
      FileUtils.mkdir_p(@path)
    end
    @file_blocks = {}
    @current_buffer = {x: 0, y: 0, data: {}}
  end

  def incr(x, y)
    hash = _hash_for(x, y)
    hash[x] ||= {}
    hash[x][y] ||= 0
    hash[x][y] += 1
    mark_dirty!
  end

  def get(x, y)
    hash = _hash_for(x, y)
    hash[x][y] if hash[x]
  end

  def delete(x, y)
    hash = _hash_for(x, y)
    if hash[x]
      hash[x].delete(y)
      mark_dirty!
    end
  end

  def _each_in_bucket(x_bucket)
    hash = _read_contents(x_from_bucket(x_bucket), 0)
    hash.each do |x, y_hash|
      y_hash.each do |y, count|
        yield count, x, y
      end
    end
  end

  def each_with_indices(&block)
    _write_buffer_if_dirty
    @file_blocks.keys.sort.each do |x_bucket|
      _each_in_bucket(x_bucket, &block)
    end
  end

  def in_range(xmin, xmax, ymin, ymax, &block)
    _write_buffer_if_dirty
    xmin_bucket = x_bucket(xmin)
    xmax_bucket = x_bucket(xmax)
    @file_blocks.keys.select {|x| x >= xmin_bucket && x <= xmax_bucket}.sort.each do |x_bucket|
      _each_in_bucket(x_bucket, &block)
    end
  end

  def x_bucket(x)
    x / 1000
  end

  def x_from_bucket(bucket)
    bucket * 1000
  end

  # In the future we might want to shard by y range, but for now
  # just do one per x.
  def y_bucket(y)
  end

  def _filename(x, y)
    File.join(@path, "x.#{x_bucket(x)}.dump")
  end

  def _read_file(x, y)
    if File.exists?(_filename(x, y))
      File.open(_filename(x, y), 'r').read
    end
  end

  def _read_contents(x, y)
    contents = _read_file(x, y)
    if contents && contents.length
      Marshal.load(contents)
    else
      {}
    end
  end

  def _write_file
    x = @current_buffer[:x]
    y = @current_buffer[:y]
    File.open(_filename(x, y), 'w') do |f|
      f.write(Marshal.dump(@current_buffer[:data]))
      @file_blocks[x_bucket(x)] = true
    end
  end

  def _write_buffer_if_dirty
    if @current_buffer[:dirty]
      _write_file
      mark_clean!
    end
  end

  def _hash_for(x, y)
    if _current_buffer_for(x, y)
      _current_buffer_for(x, y)[:data]
    else
      _write_buffer_if_dirty
      hash = _read_contents(x, y)
      _set_current_buffer(x, y, hash)
      hash
    end
  end

  def _current_buffer_for(x, y)
    f1 = _filename(x, y)
    f2 = _filename(@current_buffer[:x], @current_buffer[:y])
    if f1 == f2
      @current_buffer
    end
  end

  def _set_current_buffer(x, y, data)
    @current_buffer = {x: x, y: y, data: data}
  end

  def mark_dirty!
    @current_buffer[:dirty] = true
  end

  def mark_clean!
    @current_buffer[:dirty] = false
  end

  def destroy
    @file_blocks.keys.sort.each do |x_block|
      File.delete(_filename(x_from_bucket(x_block), 0))
    end
  end

end
