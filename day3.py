def highest_number(num: str, offset):
    digits = list(num)
    for i in reversed(range(10)):
        try:
            return str(i), digits.index(str(i)) + offset
        except:
            continue
    return None


def solve(input_file):
    f = open(input_file, 'r')
    lines = f.read().splitlines()

    def part1():
        total = 0
        for line in lines:
            first, idx_first = highest_number(line[:-1], 0)
            second, _ = highest_number(line[idx_first + 1:], 0)
            num = int(first + second)
            total += num
        return total

    def part2():
        total = 0
        for line in lines:
            digits = []
            last_idx = -1
            for i in range(12):
                end = -(11 - i)
                if end == 0:
                    end = None
                next, last_idx = highest_number(line[last_idx + 1:end], last_idx + 1)
                digits.append(next)
            num = int(''.join(digits))
            total += num
        return total
        
    print('day 3')
    print('part 1:', part1())
    print('part 2:', part2())

if __name__ == '__main__':
    solve('inputs/3.txt')
