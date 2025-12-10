lines = File.readlines "inputs/7.txt"

test_data = [
    '.......S.......',
    '.......|.......', # 1
    '......|^|......', # 1 1
    '......|.|......',
    '.....|^|^|.....', # 1 2 1
    '.....|.|.|.....',
    '....|^|^|^|....', # 1 3 3 1
    '....|.|.|.|....',
    '...|^|^|||^|...', # 1 4 3 3 1 1
    '...|.|.|||.|...',
    '..|^|^|||^|^|..',
    '..|.|.|||.|.|..',
    '.|^|||^||.||^|.',
    '.|.|||.||.||.|.',
    '|^|^|^|^|^|||^|',
    '|.|.|.|.|.|||.|',
]

def part1(lines)
    total = 0
    lines.each_with_index do |line, y|
        line.chars.each_with_index do |c, x|
            if c == "S" || c == "0"
                if y < lines.length - 1
                    if lines[y+1][x] == "^" # split
                        total += 1
                        if x > 0
                            lines[y+1][x-1] = "0"
                        end
                        if x < lines[y].length - 1
                            lines[y+1][x+1] = "0"
                        end
                    else
                        lines[y+1][x] = "0"
                    end
                end
            end
        end
    end
    [total, lines]
end

def part2(lines)
    lines = lines.map{|line| line.chars}
    lines.each_with_index do |line, y|
        next if y == lines.length - 1
        line.each_with_index do |c, x|
            if c == "S"
                lines[y+1][x] = 1
            elsif c.to_i == c
                if lines[y+1][x] == "^"
                    if x > 0
                        lines[y+1][x-1] = c.to_i + lines[y+1][x-1].to_i
                    end
                    if x < lines[y].length - 1
                        lines[y+1][x+1] = c.to_i + lines[y+1][x+1].to_i
                    end
                else
                    lines[y+1][x]  = c.to_i + lines[y+1][x].to_i
                end
            end
        end
    end
    lines.last.select{|x| x.to_i == x}.sum
end

num_splits, graph = part1(lines)

puts "part 1: #{num_splits}"
puts "part 2: #{part2(graph)}"
