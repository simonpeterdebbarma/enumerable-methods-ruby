module Enumerables
  # rubocop:disable Style/For
  def my_each
    if self.class == Array
      for i in (0..length - 1)
        yield (self[i])
      end
    elsif self.class == Hash
      kv = []
      keys.my_each do |k|
        kv << [k, (self[k])]
      end
      for i in (0..kv.length - 1)
        yield(kv[i])
      end
    end
  end
  # rubocop:enable Style/For
end
