import sys

n = int(sys.argv[1]) if len(sys.argv) > 1 else 0
if n == 0:
    print("Usage: array_append_remove <count>")
    exit(0)

array = []
for i in range(n):
    array.append(i)
while array:
    array.pop()

