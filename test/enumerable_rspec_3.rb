# frozen_string_literal: true

# /spec/enumerable_spec.rb
require_relative '../enumerables.rb'

RSpec.describe Enumerable do
    describe "#my_each" do
        it "Takes a block as argument" do
            expect([1,2,3].my_each {|x| x}).to eql([1,2,3])
        end
    end

    describe "#my_each_with_index" do
        it "Works with the index of each element in the array" do
            expect([1,2,3].my_each_with_index {|x, i| i}).to eql([0,1,2]) 
        end
    end

    describe "#my_select" do
        it "returns a new array with elements that pass a condition given inside a block" do
            expect([1,2,3,4].my_select {|x| x % 2 == 0}).to eql([2,4])
        end
    end

    describe "#my_all?" do
        it "returns true if every element in the array pass a condition, otherwise returns false" do
            expect([1,"2",3,4].my_all? {|x| x.is_a? Integer }).to eql(false)
        end
    end
    
    describe "#my_any?" do
        it "returns true if any of the element in the array pass a condition, otherwise returns false" do
            expect([-20,-1,0,1].my_any? {|x| x > 0}).to eql(true)
        end
    end
    
    describe "#my_none?" do
        it "returns true if none of the element in the array pass a condition, otherwise returns false" do
            expect([1,2,3,4,5].my_none? {|x| x > 6}).to eql(true)
        end
    end

    describe "#my_count" do
        it "returns the numbers of element in an array" do
            expect([1,2,3,4,5,6,7,8,9].my_count).to eql(9)
        end
    end

    describe "#my_map" do
        it "creates a new array containing the values returned by the block" do
            expect([0,1,2].my_map {|x| x + 1}).to eql([1,2,3])
        end
    end

    describe "#my_inject" do
        it "Reduce all elements of an array into an single element" do
            expect([1,2,3,4].my_inject {|a,b| a + b}).to eql(10)
        end
    end
end