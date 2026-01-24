lines = File.readlines 'inputs/10.txt'

# xor'ing twice is a noop, so we only need to worry about once. and order doesn't matter, because a ^ b ^ c == b ^ c ^ a.
# so we just need to know which xor'd combo of buttons == target?

def solve_machine(target, buttons)
  buttons.count.times do |i| # i represents number of buttons being pushed
    buttons.combination(i).each do |combo|
      if combo.reduce(:^) == target
        puts "solved #{target} with buttons #{combo} at depth #{i}"
        return i
      end
    end
  end
  0
end

def part1(lines)
  # how to calculate bit difference between target and real ^ button?
  re = /(\[[#.]+\]) ((\([\d,]+\) )+){[\d,]+}/
  machines = lines.map do |line|
    target, buttons, joltage = line.match(re).captures
    # puts "target: #{target}, buttons: #{buttons}, joltage: #{joltage}"

    # convert . and # to an integer
    target_num = target[1...-1].chars.map{|c| c == '#' ? 1 : 0}.inject(0) do |num, c|
      # puts "num: #{num}, c: #{c}, #{(num << 1) | c}"
      (num << 1) | c
    end
    # puts "target_num: #{target_num}"

    # convert buttons to integers
    panel_len = target.size - 2 - 1
    buttons = buttons.split(' ').map{|s| s[1...-1].split(',').map(&:to_i)}
    buttons = buttons.map do |button|
      button.inject(0) do |num, exp|
        num |= (2 ** (panel_len - exp))
        # puts "exp: #{exp}, num: #{num}"
        num
      end
    end
    # puts "buttons: #{buttons}"

    [target_num, buttons]
  end.to_h

  solutions = machines.map do |target, buttons|
    puts "target: #{target}, buttons: #{buttons}"
    solution = solve_machine(target, buttons)
    puts "solution: #{solution.inspect}"
    solution
  end
  puts "solutions: #{solutions.inspect}"
  solutions.sum
end

def part2(lines)

end

puts "part 1: #{part1(lines)}"
puts "part 2: #{part2(lines)}"


# def solve_machine(target, buttons)
#   puts "==================="
#   puts "target: #{target}, buttons: #{buttons}"
#   queue = buttons.map{|button| [button, 0, 1]}
#   while true
#     next_button = queue.shift
#     # puts "next button: #{next_button}"
#     state = next_button[1] ^ next_button[0]
#     if state == target
#       puts "got to #{target.to_s(2)} from #{state.to_s(2)} with button #{next_button[0].to_s(2)} and depth #{next_button[2]}"
#       return next_button[2]
#     else
#       queue += buttons.filter{|b| b != next_button[0]}.map{|b| [b, state, next_button[2] + 1]}
#     end
#   end
# end