def merge_two_ranges(a, b)
    if a[0] <= b[1] && b[0] <= a[1]
        [(a+b).min, (a+b).max]
    end
end

def merge_ranges(ranges)
    loop do
        ranges.sort_by! { |range| range[0] }
        puts "sorted: #{ranges}"
        next_ranges = []
        skip_next = false
        # puts "ranges: #{ranges}"
        ranges.each_with_index { |range, i|
            # puts "#{i} of #{ranges.count}"
            if skip_next
                skip_next = false
                next
            end
            if i != ranges.count - 1 && ranges[i][1] >= ranges[i+1][0]
                skip_next = true
                next_ranges.push([ranges[i][0], [ranges[i][1], ranges[i+1][1]].max])
                puts "merging #{ranges[i]} and #{ranges[i+1]} to make #{[ranges[i][0], [ranges[i][1], ranges[i+1][1]].max]}"
            else
                next_ranges.push(ranges[i])
            end            
        }
        if next_ranges.count == ranges.count
            return next_ranges
        end
        ranges = next_ranges
    end
end

def in_some_range(num, ranges)
    ranges.any?{|range| range[0] <= num && range[1] >= num}
end

def part1()
    lines = File.readlines("inputs/5.txt", chomp: true)
    ranges = lines.select{ |line| line.include? "-" }.map{ |range|
        range.split("-").map(&:to_i)
    }
    lines
        .select{|line| !line.include? "-"}
        .map(&:to_i)
        .select{|ingredient| in_some_range(ingredient, ranges)}
        .count
end

def part2()
    lines = File.readlines "inputs/5.txt"
    ranges = lines.select{ |line| line.include? "-" }.map{ |range|
        range.split("-").map(&:to_i)
    }
    merge_ranges ranges
    puts "merged: #{ranges}"
    ranges.reduce(0) { |total, range|
        total + (range[1] - range[0])
    }
end

puts "merged: #{merge_two_ranges([1,3], [4,7])}"
puts "merged: #{merge_two_ranges([1,6], [4,7])}"
puts "merged: #{merge_two_ranges([4,7], [1,6])}"


puts "part 1: #{part1}"
puts "part 2: #{part2}"
