require 'set'

lines = File.readlines 'inputs/8.txt'

def get_straight_line_distance(c1, c2)
  (
    (c1[0] - c2[0])**2 +
    (c1[1] - c2[1])**2 +
    (c1[2] - c2[2])**2
  )**0.5
end

def deduplicate(circuits)
  loop do
    intersection = circuits.find { |_coord, circuit_set| circuit_set.count > 1 }
    break if intersection.nil?

    a, b = intersection[1].take(2)
    circuits.each_value do |circuit_set|
      if circuit_set.include?(b)
        circuit_set.add(a)
        circuit_set.delete(b)
      end
    end
  end
end

def connect(circuits, distance, circuit_number)
  if circuits[distance[0]].empty? && circuits[distance[1]].empty?
    circuits[distance[0]].add(circuit_number)
    circuits[distance[1]].add(circuit_number)
    circuit_number += 1
  elsif circuits[distance[0]].empty? ^ circuits[distance[1]].empty?
    circuits[distance[0]] = circuits[distance[0]].union(circuits[distance[1]])
    circuits[distance[1]] = circuits[distance[0]].union(circuits[distance[1]])
  else
    circuits[distance[0]] += circuits[distance[1]]
    circuits[distance[1]] += circuits[distance[0]]
  end
  circuit_number
end

def part1(lines, num_connections)
  coords = lines.map { |line| line.split(',').map(&:to_i) }
  distances = coords
              .combination(2)
              .map { |a, b| [a, b, get_straight_line_distance(a, b)] }
              .sort_by { |_a, _b, distance| distance }
  circuits = coords.map { |coord| [coord, Set.new] }.to_h
  circuit_number = 0
  num_connections.times do |i|
    circuit_number = connect(circuits, distances[i], circuit_number)
  end
  deduplicate(circuits)
  circuit_sizes = circuit_number.times.map do |circuit_number|
    circuits.count { |_coord, circuit_set| circuit_set.include?(circuit_number) }
  end
  circuit_sizes.sort!.reverse!
  circuit_sizes[0..2].reduce(:*)
end

def part2(lines)
  coords = lines.map { |line| line.split(',').map(&:to_i) }
  distances = coords
              .combination(2)
              .map { |a, b| [a, b, get_straight_line_distance(a, b)] }
              .sort_by { |_a, _b, distance| distance }
  circuits = coords.map { |coord| [coord, Set.new] }.to_h
  circuit_number = 0
  i = 0
  loop do
    break if circuits.all? { |_coord, circuits| circuits.count == 1 }

    circuit_number = connect(circuits, distances[i], circuit_number)
    deduplicate(circuits)
    i += 1
  end
  last_connection = distances[i - 1]
  last_connection[0][0] * last_connection[1][0]
end

puts "part 1: #{part1(lines, 1000)}"
puts "part 2: #{part2(lines)}"
