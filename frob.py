import sys
from time import perf_counter_ns as time
from _libfrob_cffi import lib, ffi


start = time()
x = 0
for i in range(int(sys.argv[1])):
    x = lib.frob(x)

print("x:", x)
print("spent time:", (time() - start) / 10**6)
