# This is a scratch file for writing the solution
# in python and submitting on aoj for marking it done

import sys

t = int(input())

for line in sys.stdin:
    a, b, c = sorted(map(int, line.split()))
    if a**2 + b**2 == c**2:
        print("YES")
    else:
        print("NO")