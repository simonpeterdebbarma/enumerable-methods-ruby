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
    if block_given?
      my_each { |x| return false unless yield(x) }
      true
    elsif arg
      if arg.is_a? Regexp
        my_each { |x| return false unless x.to_s =~ arg }
      elsif arg.is_a? Class
        my_each { |x| return false unless x.is_a? arg }
      else
        my_each { |x| return false unless x == arg }
      end
    else
      my_each { |x| return false unless x }
    end
    true
  end


  def my_any?(given = nil)
    if block_given?
      my_each { |x| return true if yield(x) }
      false
    elsif given
      if given.is_a? Regexp
        my_each { |x| return true if x.to_s =~ given }
      elsif given.is_a? Class
        my_each { |x| return true if x.is_a? given }
      else
        my_each { |x| return true if x == given }
      end
    else
      my_each { |x| return true if x }
    end
    false
  end

  def my_none?(args = nil)
    if args.nil?
      return my_select { |element| element == true }.empty? unless block_given?

      my_each do |n|
        return true unless yield n
      end
    end

    return validate_none(args) unless args.nil?

    false
  end

  def validate_none(args)
    if args.is_a? Regexp
      my_select { |element| element.to_s.match(args) }.empty?
    elsif args.is_a? Class
      my_select { |element| element.class == args }.empty?
    else
      my_select { |element| element == args }.empty?
    end
  end

  def my_count *arg
    count = 0
    if !arg.empty?
        self.my_each do |obj|
            if obj == arg[0]
                count += 1
            end
       end
       return count
    end
    if !block_given?
        return self.length
    elsif self.class == Array
        (length - 1).times do |i|
            if yield(self[i])
                count += 1
            end
        end
    elsif self.class == Hash
      self.my_each do |i|
        count += 1 if yield i.to_a[0], i.to_a[1]
      end
    end
    count
  end

  def my_map(proc = nil)
    return to_enum(:my_map) if !block_given? && proc.nil?

    mapped = []

    if !proc.nil?
      my_each_with_index do |n, i|
        mapped [i] = proc.call(n)
      end
    else
      my_each_with_index do |n, i|
        mapped [i] = yield n
      end
    end
    mapped
  end

  def my_inject(*given)
    arr = to_a.dup
    if given[0].nil?
      result = arr.shift
    elsif given[1].nil? && !block_given?
      symbol = given[0]
      result = arr.shift
    elsif given[1].nil? && block_given?
      result = given[0]
    else
      result = given[0]
      symbol = given[1]
    end
    arr[0..-1].my_each do |i|
      result = if symbol
                 result.send(symbol, i)
               else
                 yield(result, i)
               end
    end
    result
  end
end

def multiply_els(array)
  array.my_inject { |multiply, n| multiply * n }
end
