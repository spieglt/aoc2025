lines = File.readlines 'inputs/11.txt'

"aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out".lines

def part1(lines)
  num_paths = 1
  graph = lines.map do |line|
    a = line.split(' ')
    [a.first[..2], a[1..]]
  end.to_h
  # puts graph.inspect
  queue = ['you']
  until queue.empty?
    current = queue.pop
    if current != 'out'
      num_paths += graph[current].count - 1
      queue += graph[current]
    end
  end
  num_paths
end

test_data_part_2 = "svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out".lines

def part2(lines)
  num_paths = 0
  graph = lines.map do |line|
    a = line.split(' ')
    [a.first[..2], a[1..]]
  end.to_h
  puts "graph: #{graph.inspect}"
  queue = [['svr', false, false]]
  until queue.empty?
    current = queue.pop
    # puts "current: #{current.inspect}, queue: #{queue}"
    if current[0] == 'out'
      if current[1] && current[2]
        num_paths += 1
      end
      next
    else
      queue += graph[current[0]].filter_map do |path|
        if path == 'dac'
          if current[2]
            # puts "found dac, had fft."
          end
          [path, true, current[2]]
        elsif path == 'fft'
          if current[1]
            # puts "found fft, had dac."
          end
          [path, current[1], true]
        else
          [path, current[1], current[2]]
        end
      end
    end
  end
  num_paths
end

puts "part 1: #{part1(lines)}"
puts "part 2: #{part2(lines)}"
