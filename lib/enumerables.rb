module Enumerables
  def my_each
    if self.class == Array
      0.upto(length - 1) do |i|
        yield (self[i])
      end
    elsif self.class == Hash
      kv = []
      keys.my_each do |k|
        kv << [k, (self[k])]
      end
      0.upto(kv.length - 1) do |i|
        yield(kv[i])
      end
    end
  end

  def my_each_with_index
    0.upto(length - 1) do |index|
      yield(self[index], index)
    end
  end
end
