module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    if self.class == Array
      0.upto(length - 1) do |i|
        yield (self[i])
      end
    elsif self.class == Hash
      v = []
      keys.my_each do |k|
        v << [k, (self[k])]
      end
      0.upto(v.length - 1) do |i|
        yield(v[i])
      end
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    if self.class == Array
      0.upto(length - 1) do |index|
        yield(self[index], index)
      end
    elsif self.class == Hash
      keys = self.keys
      keys.length.times do |i|
        key = keys[i]
        value = self[key]
        key_value = [key, value]
        yield(key_value, i)
      end
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    if self.class == Array
      selected = []
      my_each do |i|
        selected << i if yield(i)
      end
    elsif self.class == Hash
      selected = {}
      my_each do |i|
        selected[i.to_a[0]] = i.to_a[1] if yield i.to_a[0], i.to_a[1]
      end
    end
    selected
  end

  def my_all?(arg = nil)
    return my_all?(arg) if block_given? && !arg.nil?

    if block_given?
      my_each { |n| return false unless yield n }
    else
      proc = validate_args(arg)
      my_each { |n| return false unless proc.call(n) }
    end
    true
  end

  def my_none?(arg = nil)
    return my_select { |element| element == true }.empty? if !block_given? && arg.nil?

    if block_given?
      my_each { |n| return true unless yield n }
    else
      proc = validate_args(arg)
      my_each { |n| return true unless proc.call(n) }
    end
    false
  end

  def my_any?(arg = nil)
    return !my_select { |element| element }.empty? if !block_given? && arg.nil?

    if block_given?
      my_each { |n| return true if yield n }
    else
      proc = validate_args(arg)
      my_each { |n| return true if proc.call(n) }
    end
    false
  end

  def validate_args(arg)
    if arg.nil?
      proc { |e| e }
    elsif arg.is_a? Regexp
      proc { |e| e.to_s.match(arg) }
    elsif arg.is_a? Class
      proc { |e| e.class == arg }
    else
      proc { |e| e == arg }
    end
  end

  def my_count(*arg)
    count = 0
    unless arg.empty?
      my_each do |obj|
        count += 1 if obj == arg[0]
      end
      return count
    end
    return length unless block_given?

    if self.class == Array
      (length - 1).times do |i|
        count += 1 if yield(self[i])
      end
    elsif self.class == Hash
      my_each do |i|
        count += 1 if yield i.to_a[0], i.to_a[1]
      end
    end

    count
  end

  def my_map(proc = nil)
    return to_enum(:my_map) if !block_given? && proc.nil?

    map_items = []

    if !proc.nil?
      my_each_with_index do |n, i|
        map_items [i] = proc.call(n)
      end
    else
      my_each_with_index do |n, i|
        map_items [i] = yield n
      end
    end
    map_items
  end

  def my_inject(*given)
    arr = to_a.dup
    if given[0].nil?
      injected = arr.shift
    elsif given[1].nil? && !block_given?
      sym = given[0]
      injected = arr.shift
    elsif given[1].nil? && block_given?
      injected = given[0]
    else
      injected = given[0]
      sym = given[1]
    end
    arr[0..-1].my_each do |item|
      injected = if sym
                   injected.send(sym, item)
                 else
                   yield(injected, item)
                 end
    end
    injected
  end
end

def multiply_els(arr)
  arr.my_inject { |a, b| a * b }
end
