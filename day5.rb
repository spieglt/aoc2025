$lines = File.readlines "inputs/5.txt"

def merge_ranges(ranges)
    loop do
        ranges.sort_by! { |range| range[0] }
        next_ranges = []
        skip_next = false
        ranges.each_with_index { |range, i|
            if skip_next
                skip_next = false
                next
            end
            if i != ranges.count - 1 && ranges[i][1] >= ranges[i+1][0]
                skip_next = true
                next_ranges.push([ranges[i][0], [ranges[i][1], ranges[i+1][1]].max])
            else
                next_ranges.push(ranges[i])
            end            
        }
        return next_ranges if next_ranges == ranges
        ranges = next_ranges
    end
end

def in_some_range(num, ranges)
    ranges.any?{ |range| range[0] <= num && range[1] >= num }
end

def part1()
    ranges = $lines.select{ |line| line.include? "-" }.map{ |range|
        range.split("-").map(&:to_i)
    }
    $lines
        .select{|line| !line.include? "-"}
        .map(&:to_i)
        .select{|ingredient| in_some_range(ingredient, ranges)}
        .count
end

def part2()
    ranges = $lines
        .select { |line| line.include? "-" }
        .map { |range| range.split("-").map(&:to_i) }
    ranges = merge_ranges ranges
    ranges.reduce(0) { |total, range| total + (range[1] - range[0] + 1) }
end

puts "part 1: #{part1}"
puts "part 2: #{part2}"
