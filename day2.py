def split_evenly(num):
    num = str(num)
    num_digits = len(num)//2
    for i in range(1, num_digits + 1):
        sub_str = num[:i]
        if set(num.split(sub_str)) == {''}:
            return True
    return False


def solve(input_file):
    f = open(input_file, 'r')
    text = f.read()

    def part1():
        total = 0
        text_ranges = text.split(',')
        ranges = [_range.split('-') for _range in text_ranges]
        ranges = [range(int(p[0]), int(p[1])+1) for p in ranges]
        for _range in ranges:
            for i in _range:
                half = len(str(i))//2
                if str(i)[:half] == str(i)[half:]:
                    total += i
        return total

    def part2():
        total = 0
        text_ranges = text.split(',')
        ranges = [_range.split('-') for _range in text_ranges]
        ranges = [range(int(p[0]), int(p[1])+1) for p in ranges]
        # print(ranges)
        for _range in ranges:
            for i in _range:
                if split_evenly(i):
                    total += i
        return total
        
    print('day 2')
    print('part 1:', part1())
    print('part 2:', part2())

if __name__ == '__main__':
    solve('inputs/2.txt')
