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
    if !block_given?
      return self.my_all? { |obj| obj }
    end

    if self.class == Array
        self.length-1.times do |i|
            if yield(self[i])
              return true
            end
        end
    elsif self.class == Hash
        k = self.keys
        k.length-1.times do |i|
            if yield(k[i], self[k[i]])
                return true
            end
        end
    end
    false
  end

  def my_any?
    if !block_given?
      return self.my_any? { |obj| obj}
    end
    if self.class == Array
      length = self.size - 1
      self.length.times do |i|
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
    if !block_given?
      return self.my_none? { |obj| obj}
    end

    if self.class == Array
        self.length-1.times do |i|
            if yield(self[i])
              return false
            end
        end
    elsif self.class == Hash
        k = self.keys
        k.length-1.times do |i|
            if yield(k[i], self[k[i]])
                return false
            end
        end
    end
    true
  end


end
