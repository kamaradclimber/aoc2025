#!/usr/bin/env ruby

class String
  def any?
    !self.empty?
  end
end

input = File.read('input.txt').split("\n")
ranges = input.take_while(&:any?).map { |l| l.split('-').map(&:to_i) }
ranges = ranges.map {|r| (r.first..r.last)}

ingredients = input.reverse.take_while(&:any?).map(&:to_i)

# part1
part1 = ingredients.select { |i| ranges.any? { |r| r.include?(i) }}.size
puts "Part1: #{part1}"

class Range
  def intersect?(range)
    range.include?(self.max) || range.include?(self.min) || self.include?(range.min) || self.include?(range.max)
  end

  def merge(range)
    ([self.min,range.min].min..[self.max,range.max].max)
  end
end

# let's merge the ranges
require 'set'
continue = true
real_ranges = ranges.map {|r| (r.first..r.last)}
merged_ranges = real_ranges

while continue do
  continue = false
  future = Set.new
  merged_ranges.each do |range|
    r = future.find { |r| r.intersect?(range) }
    if r
      future.delete(r)
      future << r.merge(range)
      continue = true
    else
      future << range
    end
  end
  merged_ranges = future
end

merged_ranges= merged_ranges.sort_by(&:min)
# puts merged_ranges.map(&:itself)

# consistency with part1: are all ingredients that were considered fresh parts of the new ranges: part 1 again
raise "broken invariant" if part1 != ingredients.select { |i| merged_ranges.any? { |r| r.include?(i) }}.size

puts "Part2: #{merged_ranges.map(&:size).sum}"

