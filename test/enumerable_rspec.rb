# frozen_string_literal: true

require '../enumerables'

RSpec.describe Enumerable do
  let(:enum) do
    obj = Object.new

    def obj.each_arg(a, b = :b, *rest)
      yield a
      yield b
      yield rest
      :method_returned
    end

    obj.to_enum :each_arg, :a, :x
  end
  let(:range) { (1..10) }
  let(:arr_random) { [:a, :x, []] }
  let(:acc_num) { 2 }
  let(:acc_str) { 'pet' }
  let(:animals) { %w[rabbit bear cat] }
  let(:regexp) { /t/ }
  let(:arr_i) { [1, 2, 3, 4, 5, 2] }
  let(:arr_f) { [1, 3.14, 42] }
  let(:arr_sym) { %i[foo bar] }
  let(:arr_numeric) { [1, 2i, 3.14] }
  let(:arr_with_nil) { [nil, true, 99] }
  let(:arr_empty) { [] }
  let(:general_class) { Float }
  let(:arr_with_false) { [nil, false] }
  let(:arr_with_true) { [nil, false, true] }

  let(:itself) { proc { |x| x } }
  let(:to_square) { proc { |x| x * x } }
  let(:to_str) { proc { 'dog' } }
  let(:sym_check) { proc { |x| x == :foo } }
  let(:even_check) { proc { |x| x.even? } }
  let(:compare_word) { proc { |word| word.length >= 4 } }
  let(:acc_plus) { proc { |acc, n| acc + n } }
  let(:acc_mult) { proc { |acc, n| acc * n } }

  describe '#my_each' do
    it 'returns itself - range' do
      expect(range.my_each { itself }).to eql(range.each { itself })
    end

    it 'returns itself - array' do
      expect(arr_random.my_each { itself }).to eql(arr_random.each { itself })
    end

    it 'returns :method_returned' do
      expect(enum.my_each { itself }).to eql(enum.each { itself })
    end

    it 'returns the enumerator of the receiver - enum' do
      expect(enum.my_each).to be_an Enumerator
    end

    it 'returns the enumerator of the receiver - range' do
      expect(range.my_each).to be_an Enumerator
    end

    it 'returns the enumerator of the receiver - array' do
      expect(arr_random.my_each).to be_an Enumerator
    end
  end

  describe '#my_each_with_index' do
    it 'returns itself if block and two arguments' do
      hash = {}
      expect(animals.my_each_with_index { |item, index| hash[item] = index })
        .to eql(animals.each_with_index { |item, index| hash[item] = index })
    end

    it 'returns an enumerator if no block is given' do
      expect(animals.my_each_with_index).to be_an Enumerator
    end
  end

  describe '#my_select' do
    it 'returns an array of the results for range' do
      expect(range.my_select { even_check }).to eql(range.select { even_check })
    end

    it 'returns an array of the results for number array' do
      expect(arr_i.my_select { even_check }).to eql(arr_i.select { even_check })
    end

    it 'returns an array of the results for symbol array' do
      expect(arr_sym.my_select { sym_check }).to eql(arr_sym.select { sym_check })
    end

    it 'returns the enumerator of the receiver - Enum' do
      expect(enum.my_select).to be_an Enumerator
    end

    it 'returns the enumerator of the receiver - Range' do
      expect(range.my_select).to be_an Enumerator
    end

    it 'returns the enumerator of the receiver - Array' do
      expect(arr_i.my_select).to be_an Enumerator
    end
  end

  describe '#my_all?' do
    it 'returns true or false with block' do
      expect(animals.my_all? { compare_word })
        .to eql(animals.all? { compare_word })
    end

    it 'returns true or false matching with pattern - Regexp class' do
      expect(animals.my_all?(regexp)).to eql(animals.all?(regexp))
    end

    it 'returns true or false matching with pattern - general classes' do
      expect(arr_numeric.my_all?(Numeric)).to eql(arr_numeric.all?(Numeric)) # true
    end

    it 'returns true or false for that all elements is true including nil array' do
      expect(arr_with_nil.my_all?).to eql(arr_with_nil.all?) # false
    end

    it 'returns true or false for that all elements is true within empty array' do
      expect(arr_empty.my_all?).to eql(arr_empty.all?) # true
    end
  end

  describe '#my_any?' do
    it 'returns true or false with block' do
      expect(animals.my_any? { compare_word }).to eql(animals.any? { compare_word })
    end

    it 'returns true or false matching with pattern - Regexp' do
      expect(animals.my_any?(regexp)).to eql(animals.any?(regexp))
    end

    it 'returns true or false for that any of elements is true including nil array' do
      expect(arr_with_nil.my_any?).to eql(arr_with_nil.any?)
    end

    it 'returns true or false for that any of elements is true within empty array' do
      expect(arr_empty.my_any?).to eql(arr_empty.any?)
    end
  end

  describe '#my_none?' do
    it 'returns true or false with block' do
      expect(animals.my_none? { compare_word })
        .to eql(animals.none? { compare_word })
    end

    it 'returns true or false matching with pattern - Regexp' do
      expect(animals.my_none?(regexp)).to eql(animals.none?(regexp))
    end

    it 'returns true or false matching with pattern - general_class' do
      expect(arr_f.my_none?(general_class)).to eql(arr_f.none?(general_class))
    end

    it 'returns true or false without pattern or block including false array' do
      expect(arr_with_false.my_none?).to eql(arr_with_false.none?)
    end

    it 'returns true or false without pattern or block including true array' do
      expect(arr_with_true.my_none?).to eql(arr_with_true.none?)
    end
  end

  describe '#my_count' do
    it 'returns the number of the elements with no given condition - enumerator' do
      expect(enum.my_count).to eql(enum.count)
    end

    it 'returns the number of the elements with no given condition - array' do
      expect(arr_i.my_count).to eql(arr_i.count)
    end

    it 'returns the number of the elements with no given condition - range' do
      expect(range.my_count).to eql(range.count)
    end

    it 'returns the number of the elements matching with pattern' do
      expect(arr_i.my_count(2)).to eql(arr_i.count(2))
    end

    it 'returns the number of the elements matching with block' do
      expect(arr_i.my_count { even_check }).to eql(arr_i.count { even_check })
    end
  end

  describe '#my_map' do
    it 'returns a new array using process call' do
      expect(animals.my_map(&:to_i)).to eql(animals.map(&:to_i))
    end

    it 'returns a new array through the block - string array' do
      expect(animals.my_map { to_str }).to eql(animals.map { to_str })
    end

    it 'returns a new array through the block - range' do
      expect(range.my_map { to_square }).to eql(range.map { to_square })
    end

    it 'returns a new array through the block - number array' do
      expect(arr_i.my_map { to_square }).to eql(arr_i.map { to_square })
    end

    it 'returns itself if no block is given - enumerator' do
      expect(enum.my_map).to be_an Enumerator
    end

    it 'returns an enumerator if no block is given - array' do
      expect(arr_i.my_map).to be_an Enumerator
    end

    it 'returns an enumerator if no block is given - range' do
      expect(range.my_map).to be_an Enumerator
    end
  end

  describe '#my_inject' do
    it 'returns accumulated result only with block - string array' do
      expect(animals.my_inject { acc_plus }).to eql(animals.inject { acc_plus })
    end

    it 'returns accumulated result only with block - range' do
      expect(range.my_inject { acc_plus }).to eql(range.inject { acc_plus })
    end

    it 'returns accumulated result only with block - number array' do
      expect(arr_i.my_inject { acc_plus }).to eql(arr_i.inject { acc_plus })
    end

    it 'returns accumulated result with parameter and block - string array' do
      expect(animals.my_inject(acc_str) { acc_plus })
        .to eql(animals.inject(acc_str) { acc_plus })
    end

    it 'returns accumulated result with parameter and block - range' do
      expect(range.my_inject(acc_num) { acc_mult })
        .to eql(range.inject(acc_num) { acc_mult })
    end

    it 'returns accumulated result with parameter and block - number array' do
      expect(arr_i.my_inject(acc_num) { acc_mult })
        .to eql(arr_i.inject(acc_num) { acc_mult })
    end
  end
end