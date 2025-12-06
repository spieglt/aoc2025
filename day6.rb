lines = File.readlines "inputs/6.txt"

def part1(lines)
    total = 0
    rows = lines.map(&:split)
    rows = rows.map do |row| 
        row.map do |num|
            begin
                Integer(num)
            rescue
                num
            end
        end
    end
    rows[0].each_index do |i|
        if rows[4][i] == "*"
            total += rows[0][i] * rows[1][i] * rows[2][i] * rows[3][i]
        else
            total += rows[0][i] + rows[1][i] + rows[2][i] + rows[3][i]
        end
    end
    total
end

def part2(lines)
    total = 0
    operator = nil
    temp_nums = []
    rows = lines
    rows[0].length.times do |x|
        # if column is empty, perform equation, add to total, clear temp_nums, clear operator
        if 4.times.all? { |y| rows[y][x] == " " }
            total += temp_nums.reduce(operator)
            temp_nums = []
            operator = nil
        end
        # set operator for this equation if present
        case rows[4][x]
        when "+"
            operator = :+
        when "*"
            operator = :*
        end
        # add current number to temp_nums
        temp_num = ""
        4.times do |y|
            if "0123456789".include?(rows[y][x])
                temp_num += rows[y][x]
            end
        end
        if temp_num != ""
            temp_nums << temp_num.to_i
        end
        # if at last number, perform equation, add to total
        if x == rows[0].length - 1
            total += temp_nums.reduce(operator)
        end
    end
    total
end

puts "part 1: #{part1(lines)}"
puts "part 2: #{part2(lines)}"
