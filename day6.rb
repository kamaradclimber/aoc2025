#!/usr/bin/env ruby

lines = File.read('input.txt').split("\n").map { |line| line.split(/ +/).reject(&:empty?) }

results = lines.transpose.map do |computation|
  computation[0..computation.size-2].map(&:to_i).reduce do |memo,el|
    case computation.last
    when '+'
      memo + el
    when '*'
      memo * el
    end
  end
end

part1 = results.sum

puts "Part1: #{part1}"

def pad(s, size)
  s + ' '*(size-s.size)
end

lines = File.read('input.txt').split("\n")
operations = pad(lines.last, lines.map(&:size).max) + ' /'
numbers = lines[0..lines.size-2]

start_idx=0
current_op = operations[0]
res = 0
operations.chars.drop(1).each_with_index do |char, idx|
  next if char == ' '
  cephalopod_numbers = (start_idx...idx).map do |column|
    ns = numbers.map { |line| line[column] }.reject { |n| n == ' ' }.map(&:to_i)
    ns.reduce do |memo, el|
      memo * 10 + el.to_i
    end
  end
  res += cephalopod_numbers.reduce do |memo, el|
    case current_op
    when '+'
      memo + el
    when '*'
      memo * el
    end
  end
  
  start_idx = idx + 1
  current_op = char
end

part2 = res
puts "Part2: #{part2}"
