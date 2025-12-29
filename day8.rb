# frozen_string_literal: true

# for each coordinate, make a map of every other coordinate.
# for every other coordinate, calculate the absolute value of the difference between them.
# take the minimum of sums of those differences: that's the closest for that coordinate.
# sort coordinates by closest neighbors.
# pop a coordinate once it's been connected.
# join it to a new or existing circuit.
# we need the product of the three largest circuits, so no need to keep track of all circuit sizes. just the ones of size > 1.

require 'set'

lines = File.readlines 'inputs/8.txt'

def get_straight_line_distance(c1, c2)
  (
    (c1[0] - c2[0])**2 +
    (c1[1] - c2[1])**2 +
    (c1[2] - c2[2])**2
  ) ** 0.5
end

def part1(lines)
  coords = lines.map { |line| line.split(',').map(&:to_i) }
  distances = coords.combination(2).map{|a, b| [a, b, get_straight_line_distance(a, b)]}.sort_by{|a, b, distance| distance}

  # look up a connection. if either coordinate is in a circuit, add that circuit to the other.
  # how to collapse circuits into one? if any connection is a member of multiple circuits, those need to be collapsed.
  # tag all members of B with A, remove tag B from all members

  circuits = coords.map { |coord| [coord, Set.new] }.to_h
  circuit_number = 0
  # distances.each do |distance|
  1000.times do |i|
    distance = distances[i]
    # if neither coord is in a circuit, make a new circuit with the two of them
    if circuits[distance[0]].empty? && circuits[distance[1]].empty?
      puts "making new circuit #{circuit_number} between #{distance[0]} and #{distance[1]}"
      circuits[distance[0]].add(circuit_number)
      circuits[distance[1]].add(circuit_number)
      circuit_number += 1
    elsif circuits[distance[0]].empty? ^ circuits[distance[1]].empty?
      if circuits[distance[0]].empty?
        puts "adding #{distance[0]} to circuit #{circuits[distance[1]]} with #{distance[1]}"
      elsif circuits[distance[1]].empty?
        puts "adding #{distance[1]} to circuit #{circuits[distance[0]]} with #{distance[0]}"
      else
        raise 'oh no'
      end
      circuits[distance[0]] = circuits[distance[0]].union(circuits[distance[1]])
      circuits[distance[1]] = circuits[distance[0]].union(circuits[distance[1]])
    else
      puts "merged two sets: #{distance[0]} #{circuits[distance[0]]} ; #{distance[1]} #{circuits[distance[1]]}"
      circuits[distance[0]] += circuits[distance[1]]
      circuits[distance[1]] += circuits[distance[0]]
    end
  end

  # get list of circuit tags (which is just 0..circuit number), for each, look through circuits
  # if present on a coord with other circuits, do the A/B thing
  puts 'circuits:'
  circuits.each { |coord, circuit_set| puts "#{coord}: #{circuit_set}" }
  loop do
    intersection = circuits.find { |_coord, circuit_set| circuit_set.count > 1 }
    break if intersection.nil?

    puts 'deduplicating'
    a, b = intersection[1].take(2)
    circuits.each_value do |circuit_set|
      if circuit_set.include?(b)
        circuit_set.add(a)
        circuit_set.delete(b)
      end
    end
  end

  circuit_number.times do |circuit_number|
    num_in_circuit = circuits.count { |_coord, circuit_set| circuit_set.include?(circuit_number) }
    puts "circuit number #{circuit_number} includes #{num_in_circuit} coordinates"
  end

  circuit_sizes = circuit_number.times.map do |circuit_number|
    circuits.count { |_coord, circuit_set| circuit_set.include?(circuit_number) }
  end
  circuit_sizes.sort!
  puts "circuit sizes: #{circuit_sizes}"
end

def part2(lines); end
test_data = [
  '162,817,812',
  '57,618,57',
  '906,360,560',
  '592,479,940',
  '352,342,300',
  '466,668,158',
  '542,29,236',
  '431,825,988',
  '739,650,466',
  '52,470,668',
  '216,146,977',
  '819,987,18',
  '117,168,530',
  '805,96,715',
  '346,949,466',
  '970,615,88',
  '941,993,340',
  '862,61,35',
  '984,92,344',
  '425,690,689'
]

puts "part 1: #{part1(lines)}"
puts "part 2: #{part2(lines)}"
