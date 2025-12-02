def calc(position, num):
    new_position = position + num
    ticks = abs(new_position) // 100
    if position > 0 and new_position < 0:
        ticks += 1
    if new_position == 0:
        ticks += 1
    return new_position, ticks

def solve(input_file):
    def part1(input_file):
        position = 50
        zeroes = 0
        f = open(input_file, 'r')
        for line in f:
            num = int(line[1:])
            if line[0] == 'L':
                position -= num
            else:
                position += num
            position %= 100
            if position == 0:
                zeroes += 1
        return zeroes
    def part2(input_file):
        position = 50
        ticks = 0
        f = open(input_file, 'r')
        for line in f:
            num = int(line[1:])
            if line[0] == 'L':
                position, new_ticks = calc(position, -num)
                ticks += new_ticks
            else:
                position, new_ticks = calc(position, num)
                ticks += new_ticks
            position %= 100
        return ticks
    print('day 1')
    print('part 1:', part1(input_file))
    print('part 2:', part2(input_file))

if __name__ == '__main__':
    solve('inputs/1.txt')
