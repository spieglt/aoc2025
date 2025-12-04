
def neighbors(x, y)
    return [
        [x - 1, y],
        [x + 1, y],
        [x, y - 1],
        [x, y + 1],
        [x - 1, y - 1],
        [x - 1, y + 1],
        [x + 1, y - 1],
        [x + 1, y + 1],
    ]
end

def count_neighbors(coords)
    coords.each do |coord, _|
        neighbors(coord[0], coord[1]).each do |neighbor|
            if coords.key?(neighbor)
                coords[neighbor] += 1
            end
        end
    end
end

def get_coords(lines)
    coords = {}
    lines.each.with_index do |line, y|
        line.each_char.with_index do |char, x|
            if char == "@"
                coords[[x,y]] = 0
            end
        end
    end
    coords
end

def part1()
    lines = File.readlines "inputs/4.txt"
    coords = get_coords lines
    count_neighbors coords
    coords.select{|_, num_neighbors| num_neighbors < 4}.count
end

def part2()
    lines = File.readlines "inputs/4.txt"
    coords = get_coords lines
    count_neighbors coords
    done = false
    removed = 0
    while !done
        new_coords = {}
        done = true
        coords.each do |coord, num_neighbors|
            if num_neighbors < 4
                removed += 1
                done = false
            else
                new_coords[coord] = 0
            end
        end
        coords = new_coords
        count_neighbors coords
    end
    removed
end

puts "part 1: #{part1}"
puts "part 2: #{part2}"
