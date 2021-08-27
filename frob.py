from platform import python_implementation
import sys
from time import perf_counter as time
from _libfrob_cffi import lib, ffi


count = int(sys.argv[1])
start = time()
x = 0
for i in range(count):
    x = lib.frob(x)

delta = (time() - start) * 10 ** 3
print("out: {} C FFI wall-clock time:".format(python_implementation()), delta)
print("out: ", x)

