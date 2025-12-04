#!/usr/bin/env ruby

grid = File.read('input.txt').split("\n").map do |rows|
  rows.chars
end

def paper_neighbors(grid, x, y)
  grid_size = grid.size # it's a square
  candidates = [
    [x-1,y-1],
    [x-1,y],
    [x-1,y+1],
    [x,y-1],
    [x,y+1],
    [x+1,y-1],
    [x+1,y],
    [x+1,y+1]
  ]
  candidates.select do |xx,yy|
    next false if xx < 0 || xx >= grid_size || yy < 0 || yy >= grid_size
    grid[xx][yy] == '@'
  end.size
end

count = 0
grid.each_with_index do |row, x|
  row.each_with_index do |el, y|
    next if el != '@'
    next if paper_neighbors(grid, x,y) >= 4
    count += 1
  end
end

# part 1
puts count

# part2

# make a list of all existing items
require 'set'
known_items = Set.new
grid.each_with_index do |row, x|
  row.each_with_index do |el, y|
    known_items.add([x,y]) if el == '@'
  end
end
removed_items = Set.new

count = 0
should_continue = true
while should_continue do
  should_continue = false
  to_remove = []
  known_items.each do |x,y|
    next if paper_neighbors(grid, x,y) >= 4

    should_continue = true
    to_remove << [x,y]
  end
  count += to_remove.size
  # now removing them
  to_remove.each do |x,y|
    known_items.delete([x,y])
    grid[x][y] = '.'
  end
end

puts count
