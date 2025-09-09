# This is a scratch file for writing the solution
# in python and submitting on aoj for marking it done

from math import comb
import sys

def count_solutions(n):
    total = 0
    for k in range(5):  # k = number of variables forced ≥ 10
        m = n - 10*k
        if m < 0:
            continue
        total += (-1)**k * comb(4, k) * comb(m+3, 3)
    return total

def main():
    for line in sys.stdin:
        n = int(line.strip())
        print(count_solutions(n))

if __name__ == "__main__":
    main()
