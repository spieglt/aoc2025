lines = File.readlines 'inputs/9.txt'

def part1(lines)
  coords = lines.map{|l| l.chomp.split(",").map(&:to_i)}
  ordered = coords.sort_by(&:sum)
  max_x = coords.map{|c| c[0]}.max
  flipped = coords.map{|c| [max_x - c[0], c[1]]}.sort_by(&:sum).map{|c| [max_x - c[0], c[1]]}
  ordered_biggest = (ordered.last[0] - ordered.first[0] + 1) * (ordered.last[1] - ordered.first[1] + 1)
  flipped_biggest = (flipped.first[0] - flipped.last[0] + 1) * (flipped.last[1] - flipped.first[1] + 1)
  [ordered_biggest, flipped_biggest].max
end

def part2(lines)
  # make the border, then start in a corner and mark every . , adding them to the queue to check
  # once filled, do what we did in part 1, rejecting the result if any spaces inbetween not marked and proceeding to next pair?
  # too long? can bail early. but 

  # make the grid
  coords = lines.map{|l| l.chomp.split(",").map(&:to_i)}
  max_x = coords.map{|c| c[0]}.max + 1
  max_y = coords.map{|c| c[1]}.max + 1
  grid = []
  max_y.times { grid.append(['.'] * max_x)}

  greens = []

  # mark the red squares
  coords.each_with_index{|coord, i|
    puts "coord: #{coord}, i: #{i}, spot: #{grid[coord[1]][coord[0]]}"
    grid[coord[1]][coord[0]] = '#'
    next_coord = i == coords.count - 1 ? coords[0] : coords[i+1]
    puts "next: #{next_coord}"
    # mark the green squares
    if coord[1] == next_coord[1]
      # increment along row
      from, to = [coord[0], next_coord[0]].sort
      (from + 1...to).each do |x|
        grid[coord[1]][x] = 'X'
        greens.append(x, coord[1])
      end
    elsif coord[0] == next_coord[0]
      # increment along column
      from, to = [coord[1], next_coord[1]].sort
      (from + 1...to).each do |y|
        grid[y][coord[0]] = 'X'
        greens.append(coord[0], y)
      end
    end
  }

  # find interior blank space
  starting_coord = if coords[0][0] < coords[1][0]
    # traveling right, so go one right, one down
    [coords[0][0] + 1, coords[0][1] + 1]
  elsif coords[0][0] > coords[1][0]
    # traveling left, so go one left, one up
    [coords[0][0] - 1, coords[0][1] - 1]
  elsif coords[0][1] > coords[1][1]
    # traveling down, so go one down, one left
    [coords[0][0] - 1, coords[0][1] - 1]
  elsif coords[0][1] < coords[1][1]
    # traveling up, so go one up, one right
    [coords[0][0] - 1, coords[0][1] - 1]
  else
    raise "uh oh: #{coords[0][0]}, #{coords[1][0]}"
  end

  puts "start: #{starting_coord}"
  raise "uh oh" if grid[starting_coord[1]][starting_coord[0]] != "."

  # crawl in every direction
  queue = [starting_coord]
  while !queue.empty?
    location = queue.pop
    [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0],
    ].each do |direction|
      neighbor = [location[0] + direction[0], location[1] + direction[1]]
      if !coords.include?(neighbor) && !greens.include?(neighbor)
        queue.append(neighbor)
        greens.append(neighbor)
      end
      if grid[neighbor[1]][neighbor[0]] == '.'
        queue.append(neighbor)
        grid[neighbor[1]][neighbor[0]] = 'X'
      end
    end
  end

  grid.each{|row| puts row.inspect}
end

test_data = "7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3".lines

puts "part 1: #{part1(lines)}"
puts "part 2: #{part2(test_data)}"
