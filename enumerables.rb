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

  def my_all?
    return my_all? { |obj| obj } unless block_given?

    if self.class == Array
      length - 1.times do |i|
        return true if yield(self[i])
      end
    elsif self.class == Hash
      k = keys
      k.length - 1.times do |i|
        return true if yield(k[i], self[k[i]])
      end
    end
    false
  end

  def my_any?
    return my_any? { |obj| obj } unless block_given?

    if self.class == Array
      (length - 1).times do |i|
          if yield(self[i])
              return true
          end
      end
  elsif self.class == Hash
      keys = self.keys
      keys.length.times do |i|
          if yield(keys[i], self[keys[i]])
              return true
          end
      end
  end
  false
  end

  def my_none?
    return my_none? { |obj| obj } unless block_given?

    if self.class == Array
      length - 1.times do |i|
        return false if yield(self[i])
      end
    elsif self.class == Hash
      k = keys
      k.length - 1.times do |i|
        return false if yield(k[i], self[k[i]])
      end
    end
    true
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

  def my_inject *initial
    
  end
end
