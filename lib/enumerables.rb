module Enumerables
  def my_each
    if self.class == Array
      (0..length - 1).each do |i|
        yield (self[i])
      end
    elsif self.class == Hash
      kv = []
      keys.my_each do |k|
        kv << [k, (self[k])]
      end
      (0..kv.length - 1).each do |i|
        yield(kv[i])
      end
    end
  end
end
