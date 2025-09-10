# This is a scratch file for writing the solution
# in python and submitting on aoj for marking it done

import sys
import math

def read_point():
    """Read a point (x, y) from stdin, return None at EOF."""
    line = sys.stdin.readline()
    if not line:
        return None
    try:
        x, y = map(float, line.split())
        return (x, y)
    except ValueError:
        return None

def area_triangle(a, b, c):
    """Compute area of triangle (a, b, c)."""
    x1, y1 = a
    x2, y2 = b
    x3, y3 = c
    return abs(x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2)) / 2.0

def solve():
    """Read 4 points and check if 4th point lies inside triangle of first 3."""
    a = read_point()
    if a is None:
        return False
    b = read_point()
    c = read_point()
    p = read_point()
    if b is None or c is None or p is None:
        return False

    area_abc = area_triangle(a, b, c)
    area_sum = (
        area_triangle(a, b, p) +
        area_triangle(a, p, c) +
        area_triangle(p, b, c)
    )

    if abs(area_abc - area_sum) <= 1e-9:
        print("YES")
    else:
        print("NO")

    return True

def main():
    while solve():
        pass

if __name__ == "__main__":
    main()
