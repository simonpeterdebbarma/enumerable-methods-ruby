require_relative '../enumerables.rb'


RSpec.describe Enumerable do
    let(:array){[1,2,3,4,5]}

    describe "#my_each" do
        it "loops through an array of items"do
            expect(array.my_each{|x| x}).to eql(array)
        end
    end

    describe "#my_each_with_index" do
        it "loops through an array and returns items with their indices" do
            array_item_index_pair_orig = []
            array_item_index_pair_cust = []
            array.my_each_with_index{|x,i| array_item_index_pair_cust.push([x,i])}
            array.each_with_index{|x,i| array_item_index_pair_orig.push([x,i])}
            expect(array_item_index_pair_cust).to eql(array_item_index_pair_orig)
        end
    end

    describe "#my_map" do
        it "returns the result of running the block for each element" do
            expect(array.my_map{|n| n*2}).to eql([2,4,6,8,10])
        end
    end

    describe "#my_count" do
        it "returns the length of an array" do
            expect(array.my_count{|x| x}).to eql(5)
        end
    end

    describe "#my_all?" do
        it "returns true when a condition is true for all elements, false otherwise" do
            expect(array.my_all?{|x| x>=1}).to eql(true)
        end
    end

    describe "#my_any?" do
        it "returns true if any elements returns true for the condition, false otherwise" do
            expect(array.my_any?{|x| x==1}).to eql(true)
        end
    end

    describe "#my_none?" do
        it "returns true if no element meets the condition, false otherwise" do
            expect(array.my_none?{|x| x==1}).to eql(false)
        end
    end

    describe "#my_select" do
        it "returns only elements that meet the condition in the block" do
            expect(array.my_select{|x| x%2==0}).to eql([2,4])
        end
    end

    describe "#my_inject" do
        it "combines all elements of enum by applying a binary operation" do
            expect(array.my_inject{|x,i| x+i}).to eql(15)
        end
    end

    describe "#multiply_els" do
        it "returns total of multiplying all elements in an array" do
            expect(array.multiply_els(array)).to eql(120)
        end
    end

end